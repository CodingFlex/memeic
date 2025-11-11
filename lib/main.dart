import 'package:flutter/material.dart';
import 'package:memeic/app/app.bottomsheets.dart';
import 'package:memeic/app/app.dialogs.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/helpers/flavor_config.dart';
import 'package:memeic/services/firebase_service.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Initialize Firebase service
  final firebaseService = locator<FirebaseService>();
  await firebaseService.initialize();

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
            initialRoute: Routes.onboardingauthView,
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
