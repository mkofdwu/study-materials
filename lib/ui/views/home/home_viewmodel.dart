import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/user.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _userApi = locator<UserApiService>();
  final _moduleApi = locator<ModuleApiService>();
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
      arguments: FlexibleFormPageArguments(
        title: 'Add module',
        fieldsToWidgets: {
          'moduleName': 'TextField:Module name',
        },
        onSubmit: (inputs, setErrors) async {
          if (inputs['moduleName'].isEmpty) {
            setErrors({'moduleName': 'Please enter a name'});
            return;
          }
          final module = await _moduleApi.addModule(
            _userStore.currentUser.id,
            inputs['moduleName'],
          );
          _userStore.currentUser.moduleIds.add(module.id);
          _userStore.currentUser.modules!.add(module);
          await _userApi.setUserData(_userStore.currentUser);
          notifyListeners();
          setErrors({});
          _navigationService.back();
        },
      ),
    );
  }

  Future<List<StudyMaterial>> getRecentMaterials() =>
      _materialApi.getRecentMaterials(_userStore.currentUser.id, 8);

  Future<List<StudyMaterial>> getSearchResults(String searchQuery) =>
      _materialApi.searchForMaterials(_userStore.currentUser.id, searchQuery);
}
