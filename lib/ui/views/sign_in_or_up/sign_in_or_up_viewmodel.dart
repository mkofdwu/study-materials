import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInOrUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool signingUp;
  bool isLoading = false;

  SignInOrUpViewModel(this.signingUp);

  Map<String, String> inputErrors = {};

  void toggleSignUp() {
    signingUp = !signingUp;
    notifyListeners();
  }

  Future<void> confirm() async {
    isLoading = true;
    notifyListeners();
    await (signingUp ? signUp() : signIn());
    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn() async {
    final errors = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    if (errors.isEmpty) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      inputErrors = errors;
      notifyListeners();
    }
  }

  Future<void> signUp() async {
    final errors = await _authService.signUp(
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (errors.isEmpty) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      inputErrors = errors;
      notifyListeners();
    }
  }
}
