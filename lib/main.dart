import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memeic/app/app.bottomsheets.dart';
import 'package:memeic/app/app.dialogs.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';
import 'package:memeic/firebase_options.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/helpers/flavor_config.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FlavorConfig
  FlavorConfig(
    values: const FlavorValues(
      appTitle: 'Memeic',
      enableLogging: true,
      apiKeys: {},
    ),
  );

  // Setup dependency injection first to get services
  await setupLocator();

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
