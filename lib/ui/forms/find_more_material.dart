import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/review_materials.dart';
import 'package:hackathon_study_materials/ui/widgets/resource_site_selection.dart';
import 'package:hackathon_study_materials/ui/widgets/review_found/review_found_view.dart';
import 'package:stacked_services/stacked_services.dart';

final _materialApi = locator<MaterialApiService>();
final _userStore = locator<UserStore>();
final _navigationService = locator<NavigationService>();
final _googleSearchService = locator<GoogleSearchService>();

FlexibleFormPageArguments findMoreMaterialForm(
  Function() notifyListeners,
  Topic topic,
) =>
    FlexibleFormPageArguments(
      title: 'Find more material',
      subtitle: 'Add to topic "${topic.title}"',
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
          setErrors({'searchQuery': 'Please enter a query'});
          return;
        }
        if (!RegExp(r"^[a-zA-Z0-9_\- ]+$").hasMatch(inputs['searchQuery'])) {
          setErrors(
              {'topicNames': 'You can only enter alphanumeric characters'});
          return;
        }

        searchQuery = searchQuery.trim();
        final foundMaterials = await _googleSearchService.findMaterials(
          topic.title,
          searchQuery,
          inputs['resourceSites'],
          _userStore.currentUser.numResults,
        );
        setErrors({});

        _navigationService.navigateTo(
          Routes.flexibleFormPage,
          arguments: reviewMaterialsForm(
            notifyListeners,
            {topic.title: foundMaterials},
            addToTopic: topic,
          ),
        );
      },
    );
