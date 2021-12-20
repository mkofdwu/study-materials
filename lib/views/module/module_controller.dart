import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/forms/add_topic.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form_view.dart';
import 'package:hackathon_study_materials/views/search/search_view.dart';
import 'package:hackathon_study_materials/views/topic/topic_view.dart';
import 'package:hackathon_study_materials/widgets/choice_bottom_sheet.dart';

class ModuleController extends GetxController {
  final _materialApi = Get.find<DbMaterialService>();

  final Module _module;

  ModuleController(this._module);

  void goToAddTopic() {
    Get.to(FlexibleFormView(
      form: addTopicForm(update, _module),
    ));
  }

  void goToTopic(Topic topic) {
    Get.to(TopicView(topic: topic, parentModule: _module));
  }

  void goToSearch() {
    Get.to(SearchView(module: _module));
  }

  void setSortBy() {
    Get.bottomSheet(ChoiceBottomSheet(
      title: 'Sort materials by',
      choices: const ['Date created', 'Name'],
    ));
  }

  Future<List<StudyMaterial>> getMaterials() =>
      _materialApi.getMaterials(_module.id);
}
