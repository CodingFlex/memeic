import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:memeic/app/app.bottomsheets.dart';
import 'package:memeic/app/app.dialogs.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';
import 'package:memeic/firebase_options.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/helpers/flavor_config.dart';
import 'package:memeic/services/hive_service.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: '.env');

  // Initialize FlavorConfig
  FlavorConfig(
    values: const FlavorValues(
      appTitle: 'Memeic',
      enableLogging: true,
      apiKeys: {},
    ),
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: FlavorConfig.instance.values.supabaseUrl,
    anonKey: FlavorConfig.instance.values.supabaseAnonKey,
  );

  // Initialize Hive framework for local storage
  // This sets up Hive itself (like building the library)
  // Think of this as setting up the filing cabinet framework
  // This MUST be done before setupLocator() so adapters are registered
  await HiveService.initHive();

  // Setup dependency injection - this creates and registers HiveService
  await setupLocator();

  // Initialize HiveService - this opens all the boxes (drawers)
  // Think of this as unlocking all the drawers in the filing cabinet
  final hiveService = locator<HiveService>();
  await hiveService.initialize();

  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ToastificationWrapper(
          child: MaterialApp(
            initialRoute: Routes.splashView,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorKey: StackedService.navigatorKey,
            navigatorObservers: [StackedService.routeObserver],
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF1A0B2E),
              colorScheme: ColorScheme.fromSeed(
                seedColor: kcPrimaryColor,
                brightness: Brightness.dark,
                background: const Color(0xFF1A0B2E),
                surface: const Color(0xFF1A0B2E),
              ),
            ),
          ),
        );
      },
    );
  }
}
