import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/models/user.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/forms/add_module.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form_view.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _materialApi = Get.find<DbMaterialService>();

  int currentTab = 0;
  final searchController = TextEditingController();

  User get currentUser => _authService.currentUser;

  void onSelectTab(int index) {
    currentTab = index;
    update();
  }

  void goToAddModule() {
    Get.to(FlexibleFormView(form: addModuleForm(update)));
  }

  Future<List<StudyMaterial>> getRecentMaterials() =>
      _materialApi.getRecentMaterials(_authService.currentUser.id, 8);

  Future<List<StudyMaterial>> getSearchResults(String searchQuery) =>
      _materialApi.searchForMaterials(_authService.currentUser.id, searchQuery);
}
