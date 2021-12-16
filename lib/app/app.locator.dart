// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../services/api/google_search_service.dart';
import '../services/api/material_api_service.dart';
import '../services/api/microsoft_teams_service.dart';
import '../services/api/module_api_service.dart';
import '../services/api/user_api_service.dart';
import '../services/auth_service.dart';
import '../stores/user_store.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => UserStore());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => ThemeService.getInstance());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserApiService());
  locator.registerLazySingleton(() => ModuleApiService());
  locator.registerLazySingleton(() => MaterialApiService());
  locator.registerLazySingleton(() => GoogleSearchService());
  locator.registerLazySingleton(() => MicrosoftTeamsService());
}
