import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/home/home_view.dart';

class SignInOrUpController extends GetxController {
  final _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool signingUp;
  bool isLoading = false;
  Map<String, String> inputErrors = {};

  SignInOrUpController(this.signingUp);

  void toggleSignUp() {
    signingUp = !signingUp;
    update();
  }

  Future<void> confirm() async {
    isLoading = true;
    update();
    await (signingUp ? signUp() : signIn());
    isLoading = false;
    update();
  }

  Future<void> signIn() async {
    final errors = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    if (errors.isEmpty) {
      Get.offAll(HomeView());
    } else {
      inputErrors = errors;
      update();
    }
  }

  Future<void> signUp() async {
    final errors = await _authService.signUp(
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (errors.isEmpty) {
      Get.offAll(HomeView());
    } else {
      inputErrors = errors;
      update();
    }
  }
}
