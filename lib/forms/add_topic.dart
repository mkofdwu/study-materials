import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/found_material.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/services/google_search_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/forms/review_materials.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form_view.dart';
import 'package:hackathon_study_materials/widgets/resource_site_selection.dart';

final _authService = Get.find<AuthService>();
final _googleSearchService = Get.find<GoogleSearchService>();

FlexibleForm addTopicForm(Function update, Module module) => FlexibleForm(
      title: 'Add topics',
      fieldsToWidgets: {
        'topicNames': 'TextField:Topic names (separated by comma)',
        'resourceSites': (onValueChanged) => ResourceSiteSelection(
              resourceSites: _authService.currentUser.resourceSites,
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
            _authService.currentUser.numResults,
          );
          topicToFound[name] = foundMaterials;
        }
        setErrors({});

        Get.to(FlexibleFormView(
          form: reviewMaterialsForm(update, topicToFound, module: module),
        ));
      },
    );
