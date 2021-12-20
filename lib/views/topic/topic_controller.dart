import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/forms/add_link.dart';
import 'package:hackathon_study_materials/forms/find_more_material.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form_view.dart';
import 'package:hackathon_study_materials/views/note/note_view.dart';
import 'package:hackathon_study_materials/views/search/search_view.dart';
import 'package:hackathon_study_materials/widgets/choice_bottom_sheet.dart';
import 'package:hackathon_study_materials/widgets/input_bottom_sheet.dart';
import 'package:hackathon_study_materials/widgets/yesno_bottom_sheet.dart';

class TopicController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _moduleApi = Get.find<DbModuleService>();
  final _materialApi = Get.find<DbMaterialService>();

  final Topic _topic;
  final Module _parentModule;

  String? filterByType;

  TopicController(this._topic, this._parentModule);

  void goToFindMaterial() {
    Get.to(FlexibleFormView(
      form: findMoreMaterialForm(update, _topic),
    ));
  }

  Future<List<StudyMaterial>> getMaterials(String? filterByType) =>
      _materialApi.getMaterials(
        _topic.moduleId,
        topicId: _topic.id,
        filterByType: filterByType,
      );

  void goToAddLink() {
    Get.to(FlexibleFormView(
      form: addLinkForm(update, _topic),
    ));
  }

  void goToAddNote() {
    Get.to(NoteView(
      title: '',
      content: '',
      saveNote: (title, content) async {
        final material = await _materialApi.addNote(
          _authService.currentUser.id,
          _topic.moduleId,
          _topic.id,
          title,
          content,
        );
        _topic.materialIds.add(material.id);
        update();
      },
    ));
  }

  void goToSearch() {
    Get.to(SearchView(module: _parentModule, topic: _topic));
  }

  void setFilter() async {
    if (filterByType != null) {
      filterByType = null;
      update();
      return;
    }
    final choice = await Get.bottomSheet(ChoiceBottomSheet(
      title: 'Filter materials',
      subtitle: 'Only show materials of type',
      // this does not take into account custom set types
      choices: _authService.currentUser.resourceSites
              .map((site) => site.title)
              .toList() +
          ['Note'],
    ));
    if (choice != null) {
      filterByType = choice;
      update();
    }
  }

  Future<void> showTopicOptions() async {
    final response = await Get.bottomSheet(ChoiceBottomSheet(
      title: 'Topic options',
      choices: const ['Rename topic', 'Delete topic'],
    ));
    if (response != null) {
      switch (response.data) {
        case 'Rename topic':
          final response = await Get.bottomSheet(InputBottomSheet(
            title: 'Rename topic',
            defaultText: _topic.title,
          ));
          if (response != null) {
            _topic.title = response.data;
            await _moduleApi.editTopic(_topic);
            update();
          }
          break;
        case 'Delete topic':
          final confirmed = await Get.bottomSheet(YesNoBottomSheet(
            title: 'Delete topic?',
            subtitle:
                "The topic '${_topic.title}' will be deleted, but its materials will be preserved. This action is irriversible!",
          ));
          if (confirmed) {
            _parentModule.topics.remove(_topic);
            await _moduleApi.deleteTopic(_topic);
            update();
            Get.back();
            Get.snackbar('Success', '${_topic.title} has been deleted.');
          }
          break;
      }
    }
  }
}
