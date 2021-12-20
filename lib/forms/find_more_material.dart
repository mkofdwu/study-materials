import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/google_search_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/forms/review_materials.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form_view.dart';
import 'package:hackathon_study_materials/widgets/resource_site_selection.dart';

final _authService = Get.find<AuthService>();
final _googleSearchService = Get.find<GoogleSearchService>();

FlexibleForm findMoreMaterialForm(Function update, Topic topic) => FlexibleForm(
      title: 'Find more material',
      subtitle: 'Add to topic "${topic.title}"',
      fieldsToWidgets: {
        'searchQuery': 'TextField:Search query',
        'resourceSites': (onValueChanged) => ResourceSiteSelection(
              resourceSites: _authService.currentUser.resourceSites,
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
          _authService.currentUser.numResults,
        );
        setErrors({});

        Get.to(FlexibleFormView(
          form: reviewMaterialsForm(
            update,
            {topic.title: foundMaterials},
            addToTopic: topic,
          ),
        ));
      },
    );
