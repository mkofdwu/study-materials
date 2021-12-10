import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ModuleViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _navigationService = locator<NavigationService>();
  final _googleSearchService = locator<GoogleSearchService>();

  final Module _module;

  ModuleViewModel(this._module);

  void goToAddTopic() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: FlexibleFormPageArguments(
        title: 'Add topics',
        fieldsToWidgets: {
          'topicNames': 'TextField:Topic names (separated by space)',
          'resourceSites': (onValueChanged) => ResourceSiteSelection(
                resourceSites: _userStore.currentUser.resourceSites,
                onValueChanged: onValueChanged,
              ),
        },
        onSubmit: (inputs, setErrors, back) async {
          final topicNames = inputs['topicNames'] as String;
          if (topicNames.isEmpty) {
            // TODO: only allow alphanumeric characters
            setErrors({'topicNames': 'Please enter at least one topic'});
            return;
          }

          final topicToFound = <String, List<FoundMaterial>>{};
          for (final topic in topicNames.split(',')) {
            final foundMaterials = await _googleSearchService.findMaterials(
              topic,
              inputs['resourceSites'],
              _userStore.currentUser.numResults,
            );
            topicToFound[topic] = foundMaterials;
          }

          _navigationService.navigateTo(
            Routes.flexibleFormPage,
            arguments: FlexibleFormPageArguments(
              title: 'Review materials',
              subtitle:
                  "We've gathered some study material you may be interested in. Choose which to add to MA4132",
              fieldsToWidgets: {},
              onSubmit: (inputs, setErrors, back) {},
            ),
          );
        },
      ),
    );
  }

  void goToTopic(Topic topic) {
    _navigationService.navigateTo(
      Routes.topicView,
      arguments: TopicViewArguments(topic: topic),
    );
  }
}
