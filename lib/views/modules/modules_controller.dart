import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/views/module/module_view.dart';
import 'package:hackathon_study_materials/views/search/search_view.dart';

class ModulesController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _moduleDb = Get.find<DbModuleService>();

  Future<List<Module>> getModules() =>
      _moduleDb.getUserModules(_authService.currentUser.id);

  void goToSearch() {
    Get.to(SearchView());
  }

  void goToModule(Module module) {
    Get.to(ModuleView(module: module));
  }
}