import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/add_link.dart';
import 'package:hackathon_study_materials/ui/forms/find_more_material.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:hackathon_study_materials/ui/widgets/review_found/review_found_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TopicViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _moduleApi = locator<ModuleApiService>();
  final _materialApi = locator<MaterialApiService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  final _googleSearchService = locator<GoogleSearchService>();

  final Topic _topic;
  final Module _parentModule;

  String? filterByType;

  TopicViewModel(this._topic, this._parentModule);

  void goToFindMaterial() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: findMoreMaterialForm(notifyListeners, _topic),
    );
  }

  Future<List<StudyMaterial>> getMaterials(String? filterByType) =>
      _materialApi.getMaterials(
        _topic.moduleId,
        topicId: _topic.id,
        filterByType: filterByType,
      );

  void goToAddLink() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: addLinkForm(notifyListeners, _topic),
    );
  }

  void goToAddNote() {
    _navigationService.navigateTo(
      Routes.noteView,
      arguments: NoteViewArguments(
        title: '',
        content: '',
        saveNote: (title, content) async {
          final material = await _materialApi.addNote(
            _userStore.currentUser.id,
            _topic.moduleId,
            _topic.id,
            title,
            content,
          );
          _topic.materialIds.add(material.id);
          notifyListeners();
        },
      ),
    );
  }

  void goToSearch() {
    _navigationService.navigateTo(
      Routes.searchView,
      arguments: SearchViewArguments(module: _parentModule, topic: _topic),
    );
  }

  void setFilter() async {
    if (filterByType != null) {
      filterByType = null;
      notifyListeners();
      return;
    }
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.choice,
      title: 'Filter materials',
      description: 'Only show materials of type',
      // this does not take into account custom set types
      data: _userStore.currentUser.resourceSites
              .map((site) => site.title)
              .toList() +
          ['Note'],
    );
    if (response != null && response.confirmed) {
      filterByType = response.data;
      notifyListeners();
    }
  }

  Future<void> showTopicOptions() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.choice,
      title: 'Topic options',
      data: ['Rename topic', 'Delete topic'],
    );
    if (response != null && response.confirmed) {
      switch (response.data) {
        case 'Rename topic':
          final response = await _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.input,
            title: 'Rename topic',
            data: _topic.title, // default value
          );
          if (response != null && response.confirmed) {
            _topic.title = response.data;
            await _moduleApi.editTopic(_topic);
            notifyListeners();
          }
          break;
        case 'Delete topic':
          final response = await _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.yesno,
            title: 'Delete topic?',
            description:
                "The topic '${_topic.title}' will be deleted, but its materials will be preserved. This action is irriversible!",
          );
          if (response != null && response.confirmed) {
            _parentModule.topics.remove(_topic);
            await _moduleApi.deleteTopic(_topic);
            notifyListeners();
            _navigationService.back();
            _snackbarService.showSnackbar(
              title: 'Success',
              message: '${_topic.title} has been deleted.',
            );
          }
          break;
      }
    }
  }
}
