import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/resource_site.dart';
import 'package:hackathon_study_materials/services/db_user_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/forms/resource_site.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form_view.dart';
import 'package:hackathon_study_materials/views/welcome_view.dart';
import 'package:hackathon_study_materials/widgets/yesno_bottom_sheet.dart';

class SettingsController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _userApi = Get.find<DbUserService>();

  List<ResourceSite> get resourceSites =>
      _authService.currentUser.resourceSites;
  int get numResults => _authService.currentUser.numResults;

  void addResourceSite() {
    Get.to(FlexibleFormView(
      form: resourceSiteForm(update),
    ));
  }

  void editResourceSite(ResourceSite resourceSite) {
    Get.to(FlexibleFormView(
      form: resourceSiteForm(update, resourceSite: resourceSite),
    ));
  }

  Future<void> removeResourceSite(ResourceSite resourceSite) async {
    final confirmed = await Get.bottomSheet(YesNoBottomSheet(
      title: 'Remove resource site?',
      subtitle:
          "You'll no longer search for study materials on '${resourceSite.title}' (${resourceSite.siteUrl}).",
    ));
    if (confirmed) {
      _authService.currentUser.resourceSites.remove(resourceSite);
      await _userApi.setUserData(_authService.currentUser);
      update();
    }
  }

  Future<void> onChangeNumResults(int? newNumResults) async {
    if (newNumResults != null) {
      _authService.currentUser.numResults = newNumResults;
      // could be more efficient:
      await _userApi.setUserData(_authService.currentUser);
      update();
    }
  }

  void goToProfile() {}

  // get is not updating for some reason, so a separate variable is used
  bool isDarkMode = Get.isDarkMode;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  Future<void> signOut() async {
    final confirmed = await Get.bottomSheet(YesNoBottomSheet(
      title: 'Sign out?',
      subtitle: 'Are you sure you want to sign out of your account?',
    ));
    if (confirmed) {
      _authService.signOut();
      // TODO
      Get.offAll(WelcomeView());
      Get.snackbar('Success', 'Signed out successfully');
    }
  }
}
