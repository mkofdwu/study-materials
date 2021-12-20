import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/found_material.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form.dart';
import 'package:hackathon_study_materials/widgets/review_found/review_found_view.dart';

final _moduleApi = Get.find<DbModuleService>();
final _materialApi = Get.find<DbMaterialService>();
final _authService = Get.find<AuthService>();

FlexibleForm reviewMaterialsForm(
  Function update,
  Map<String, List<FoundMaterial>> topicToFound, {
  // used by add topic(s) form
  Module? module,
  // used by add more materials form
  Topic? addToTopic,
}) =>
    FlexibleForm(
      title: 'Review materials',
      subtitle:
          "We've gathered some study material you may be interested in. Choose which to add to ${addToTopic?.title ?? module!.title}",
      fieldsToWidgets: {
        'materials': (onValueChanged) => ReviewFoundView(
              topicToFound: topicToFound,
              onValueChanged: onValueChanged,
            ),
      },
      onSubmit: (inputs, setErrors) async {
        if (addToTopic == null) {
          // create topic, add materials
          assert(module != null);
          for (final topicName in inputs['materials'].keys) {
            final topic = await _moduleApi.addTopic(module!.id, topicName);
            for (final found in inputs['materials'][topicName]) {
              if (found.selected) {
                final material = await _materialApi.addFoundMaterial(
                  _authService.currentUser.id,
                  module.id,
                  topic.id,
                  found,
                );
                topic.materialIds.add(material.id);
              }
            }
            module.topics.add(topic);
          }
        } else {
          assert(topicToFound.length == 1);
          assert(topicToFound.containsKey(addToTopic.title));
          for (final found in inputs['materials'][addToTopic.title]) {
            if (found.selected) {
              final material = await _materialApi.addFoundMaterial(
                _authService.currentUser.id,
                addToTopic.moduleId,
                addToTopic.id,
                found,
              );
              addToTopic.materialIds.add(material.id);
            }
          }
        }
        update();
        setErrors({});
        Get.back();
        Get.back();
      },
    );
