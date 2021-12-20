import 'package:get/get.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/services/db_user_service.dart';
import 'package:hackathon_study_materials/services/google_search_service.dart';

void initServices() {
  Get.put(DbMaterialService());
  Get.put(DbModuleService());
  Get.put(DbUserService());
  Get.put(GoogleSearchService());
  Get.put(AuthService());
  Get.put(AuthService());
}
