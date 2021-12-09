// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api/user_api_service.dart';
import '../services/auth_service.dart';
import '../stores/user_store.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserStore());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserApiService());
}
