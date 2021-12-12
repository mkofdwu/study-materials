import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
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

class ModuleViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _googleSearchService = locator<GoogleSearchService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _moduleApi = locator<ModuleApiService>();

  final Module _module;

  ModuleViewModel(this._module);

  void goToAddTopic() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: FlexibleFormPageArguments(
        title: 'Add topics',
        fieldsToWidgets: {
          'topicNames': 'TextField:Topic names (separated by comma)',
          'resourceSites': (onValueChanged) => ResourceSiteSelection(
                resourceSites: _userStore.currentUser.resourceSites,
                onValueChanged: onValueChanged,
              ),
        },
        onSubmit: (inputs, setErrors) async {
          final topicNames = inputs['topicNames'] as String;
          if (topicNames.isEmpty) {
            // TODO: only allow alphanumeric characters
            setErrors({'topicNames': 'Please enter at least one topic'});
            return;
          }

          final topicToFound = <String, List<FoundMaterial>>{};
          for (String name in topicNames.split(',')) {
            name = name.trim();
            final foundMaterials = await _googleSearchService.findMaterials(
              name,
              name,
              inputs['resourceSites'],
              _userStore.currentUser.numResults,
            );
            topicToFound[name] = foundMaterials;
          }

          _navigationService.navigateTo(
            Routes.flexibleFormPage,
            arguments: FlexibleFormPageArguments(
              title: 'Review materials',
              subtitle:
                  "We've gathered some study material you may be interested in. Choose which to add to ${_module.title}",
              fieldsToWidgets: {
                'materials': (onValueChanged) => ReviewFoundView(
                      topicToFound: topicToFound,
                      onValueChanged: onValueChanged,
                    ),
              },
              onSubmit: (inputs, setErrors) async {
                // create topic, add materials
                for (final topicName in inputs['materials'].keys) {
                  final topic =
                      await _moduleApi.addTopic(_module.id, topicName);
                  for (final found in inputs['materials'][topicName]) {
                    if (found.selected) {
                      final material = await _moduleApi.addFoundMaterial(
                        _userStore.currentUser.id,
                        _module.id,
                        topic.id,
                        found,
                      );
                      topic.materialIds.add(material.id);
                    }
                  }
                  _module.topics.add(topic);
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
      _moduleApi.getModuleMaterials(_module.id);
}
