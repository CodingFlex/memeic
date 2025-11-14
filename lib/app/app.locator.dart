// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/hive_service.dart';
import '../services/meme_service.dart';
import '../services/tags_service.dart';
import '../services/user_service.dart';
import '../ui/common/toast.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => ToastService());
  locator.registerLazySingleton(() => MemeService());
  locator.registerLazySingleton(() => TagsService());
  locator.registerLazySingleton(() => UserService());
}
