import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/add_topic.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:hackathon_study_materials/ui/widgets/review_found/review_found_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ModuleViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _materialApi = locator<MaterialApiService>();

  final Module _module;

  ModuleViewModel(this._module);

  void goToAddTopic() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: addTopicForm(notifyListeners, _module),
    );
  }

  void goToTopic(Topic topic) {
    _navigationService.navigateTo(
      Routes.topicView,
      arguments: TopicViewArguments(topic: topic, parentModule: _module),
    );
  }

  void goToSearch() {
    _navigationService.navigateTo(
      Routes.searchView,
      arguments: SearchViewArguments(module: _module),
    );
  }

  void setSortBy() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.choice,
      title: 'Sort materials by',
      data: ['Date created', 'Name'],
    );
  }

  Future<List<StudyMaterial>> getMaterials() =>
      _materialApi.getMaterials(_module.id);
}
