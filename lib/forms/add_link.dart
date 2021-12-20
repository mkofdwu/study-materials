import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form.dart';

final _materialApi = Get.find<DbMaterialService>();
final _authService = Get.find<AuthService>();

FlexibleForm addLinkForm(Function update, Topic topic) => FlexibleForm(
      title: 'Add material by url',
      subtitle: 'Add to topic "${topic.title}"',
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

        final material = await _materialApi.addLink(
          _authService.currentUser.id,
          topic.moduleId,
          topic.id,
          inputs['title'],
          inputs['link'],
        );
        topic.materialIds.add(material.id);
        update();
        setErrors({});
        Get.back();
      },
    );
