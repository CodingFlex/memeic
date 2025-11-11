import 'package:memeic/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:memeic/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:memeic/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:memeic/ui/views/splash/splash_view.dart';
import 'package:memeic/ui/views/onboardingauth/onboardingauth_view.dart';
import 'package:memeic/ui/views/main_navigation/main_navigation_view.dart';
import 'package:memeic/ui/views/search/search_view.dart';
import 'package:memeic/ui/views/favorites/favorites_view.dart';
import 'package:memeic/ui/views/settings/settings_view.dart';
import 'package:memeic/ui/views/meme_detail/meme_detail_view.dart';
import 'package:memeic/services/auth_service.dart';
import 'package:memeic/services/firebase_service.dart';
import 'package:memeic/ui/common/toast.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: OnboardingauthView),
    MaterialRoute(page: MainNavigationView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: FavoritesView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: MemeDetailView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirebaseService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ToastService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
