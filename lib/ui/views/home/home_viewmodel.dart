import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/user.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/add_module.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _materialApi = locator<MaterialApiService>();

  int currentTab = 0;
  final searchController = TextEditingController();

  User get currentUser => _userStore.currentUser;

  void onSelectTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  void goToAddModule() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: addModuleForm(notifyListeners),
    );
  }

  Future<List<StudyMaterial>> getRecentMaterials() =>
      _materialApi.getRecentMaterials(_userStore.currentUser.id, 8);

  Future<List<StudyMaterial>> getSearchResults(String searchQuery) =>
      _materialApi.searchForMaterials(_userStore.currentUser.id, searchQuery);
}
