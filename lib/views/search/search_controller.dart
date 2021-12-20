import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/utils/show_material_options.dart';

class SearchController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _materialApi = Get.find<DbMaterialService>();
  final _moduleApi = Get.find<DbModuleService>();

  final searchController = TextEditingController();
  Module? moduleFilter;
  Topic? topicFilter;

  SearchController(this.moduleFilter, this.topicFilter);

  void dismiss() {
    Get.back();
  }

  void removeModuleFilter() {
    moduleFilter = null;
    update();
  }

  void removeTopicFilter() {
    topicFilter = null;
    update();
  }

  Future<List<StudyMaterial>> getSearchResults(String searchQuery) =>
      _materialApi.searchForMaterials(
        _authService.currentUser.id,
        searchQuery,
        moduleId: moduleFilter?.id,
        topicId: topicFilter?.id,
      );

  Future<void> fetchAndShowMaterialOptions(StudyMaterial material) async {
    final module = await _moduleApi.getModule(material.moduleId);
    showMaterialOptions(update, module.topics, material);
  }
}
