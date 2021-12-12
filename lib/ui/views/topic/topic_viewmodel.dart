import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:hackathon_study_materials/ui/widgets/review_found/review_found_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TopicViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _moduleApi = locator<ModuleApiService>();
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
      arguments: FlexibleFormPageArguments(
        title: 'Find more material',
        subtitle: 'Add to topic "${_topic.title}"',
        fieldsToWidgets: {
          'searchQuery': 'TextField:Search query',
          'resourceSites': (onValueChanged) => ResourceSiteSelection(
                resourceSites: _userStore.currentUser.resourceSites,
                onValueChanged: onValueChanged,
              ),
        },
        onSubmit: (inputs, setErrors) async {
          String searchQuery = inputs['searchQuery'];
          if (searchQuery.isEmpty) {
            // TODO: only allow alphanumeric characters
            setErrors({'searchQuery': 'Please enter a query'});
            return;
          }

          searchQuery = searchQuery.trim();
          final foundMaterials = await _googleSearchService.findMaterials(
            _topic.title,
            searchQuery,
            inputs['resourceSites'],
            _userStore.currentUser.numResults,
          );

          _navigationService.navigateTo(
            Routes.flexibleFormPage,
            arguments: FlexibleFormPageArguments(
              title: 'Review materials',
              subtitle:
                  "We've gathered some study material you may be interested in. Choose which to add to '${_topic.title}'",
              fieldsToWidgets: {
                'materials': (onValueChanged) => ReviewFoundView(
                      topicToFound: {_topic.title: foundMaterials},
                      onValueChanged: onValueChanged,
                    ),
              },
              onSubmit: (inputs, setErrors) async {
                // create topic, add materials
                for (final found in inputs['materials'][_topic.title]) {
                  if (found.selected) {
                    final material = await _moduleApi.addFoundMaterial(
                      _userStore.currentUser.id,
                      _topic.moduleId,
                      _topic.id,
                      found,
                    );
                    _topic.materialIds.add(material.id);
                  }
                }
                notifyListeners();
                _navigationService.back();
                _navigationService.back();
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<StudyMaterial>> getMaterials(String? filterByType) =>
      _moduleApi.getMaterials(
        _topic.moduleId,
        topicId: _topic.id,
        filterByType: filterByType,
      );

  void goToAddLink() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: FlexibleFormPageArguments(
        title: 'Add material by url',
        subtitle: 'Add to topic "${_topic.title}"',
        fieldsToWidgets: {'title': 'TextField:Title', 'link': 'TextField:Link'},
        onSubmit: (inputs, setErrors) async {
          final errors = {
            if (inputs['title'].isEmpty) 'title': 'Give this material a title',
            if (inputs['link'].isEmpty)
              'link': 'Please enter a link to the study material',
          };
          if (errors.isNotEmpty) {
            setErrors(errors);
            return;
          }

          final material = await _moduleApi.addLink(
            _userStore.currentUser.id,
            _topic.moduleId,
            _topic.id,
            inputs['title'],
            inputs['link'],
          );
          _topic.materialIds.add(material.id);
          notifyListeners();
          _navigationService.back();
        },
      ),
    );
  }

  void goToAddNote() {
    _navigationService.navigateTo(
      Routes.noteView,
      arguments: NoteViewArguments(
        title: '',
        content: '',
        saveNote: (title, content) async {
          final material = await _moduleApi.addNote(
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
