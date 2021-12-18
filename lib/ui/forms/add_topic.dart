import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/review_materials.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:stacked_services/stacked_services.dart';

final _userStore = locator<UserStore>();
final _navigationService = locator<NavigationService>();
final _googleSearchService = locator<GoogleSearchService>();

FlexibleFormPageArguments addTopicForm(
  Function() notifyListeners,
  Module module,
) =>
    FlexibleFormPageArguments(
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
          setErrors({'topicNames': 'Please enter at least one topic'});
          return;
        }
        if (!RegExp(r"^[a-zA-Z0-9_\-, ]+$").hasMatch(topicNames)) {
          setErrors(
              {'topicNames': 'You can only enter alphanumeric characters'});
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
        setErrors({});

        _navigationService.navigateTo(
          Routes.flexibleFormPage,
          arguments: reviewMaterialsForm(
            notifyListeners,
            topicToFound,
            module: module,
          ),
        );
      },
    );
