import 'package:flutter/cupertino.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/utils/show_material_options.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _moduleApi = locator<ModuleApiService>();

  final searchController = TextEditingController();
  Module? moduleFilter;
  Topic? topicFilter;

  SearchViewModel(this.moduleFilter, this.topicFilter);

  void dismiss() {
    _navigationService.back();
  }

  void removeModuleFilter() {
    moduleFilter = null;
    notifyListeners();
  }

  void removeTopicFilter() {
    topicFilter = null;
    notifyListeners();
  }

  Future<List<StudyMaterial>> getSearchResults(String searchQuery) =>
      _moduleApi.searchForMaterials(
        _userStore.currentUser.id,
        searchQuery,
        moduleId: moduleFilter?.id,
        topicId: topicFilter?.id,
      );

  void fetchAndShowMaterialOptions(StudyMaterial material) {
    final module = _userStore.currentUser.modules!
        .firstWhere((module) => module.id == material.moduleId);
    showMaterialOptions(module.topics, material, notifyListeners);
  }
}
