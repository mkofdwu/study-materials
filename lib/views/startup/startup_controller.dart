import 'package:get/get.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/home/home_view.dart';
import 'package:hackathon_study_materials/views/welcome_view.dart';

class StartupController extends GetxController {
  final _authService = Get.find<AuthService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _authService.refreshCurrentUser();
    if (_authService.isSignedIn) {
      Get.offAll(HomeView());
    } else {
      Get.offAll(WelcomeView());
    }
  }
}
