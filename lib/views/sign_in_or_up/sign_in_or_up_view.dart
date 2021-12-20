import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/back_button.dart';
import 'package:hackathon_study_materials/widgets/button.dart';
import 'package:hackathon_study_materials/widgets/text_field.dart';

import 'sign_in_or_up_controller.dart';

class SignInOrUpView extends StatelessWidget {
  final bool signUp;

  const SignInOrUpView({Key? key, required this.signUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInOrUpController>(
      init: SignInOrUpController(signUp),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBackButton(),
                  SizedBox(height: 56),
                  Text(
                    controller.signingUp ? 'Sign up' : 'Sign in',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(children: [
                    Text(
                      controller.signingUp
                          ? 'Already have an account? '
                          : 'Dont have an account? ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => controller.toggleSignUp(),
                      child: Text(
                        controller.signingUp ? 'Sign in' : 'Sign up',
                        style: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 72),
                  MyTextField(
                    controller: controller.emailController,
                    hintText: 'Email',
                    error: controller.inputErrors['email'],
                  ),
                  SizedBox(height: 28),
                  MyTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    error: controller.inputErrors['password'],
                  ),
                  SizedBox(height: 28),
                  if (controller.signingUp)
                    MyTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm password',
                      obscureText: true,
                      error: controller.inputErrors['confirmPassword'],
                    ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyButton(
                      text: 'Confirm',
                      isLoading: controller.isLoading,
                      onPressed: controller.confirm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
