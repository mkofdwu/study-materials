import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:hackathon_study_materials/ui/widgets/text_field.dart';
import 'package:stacked/stacked.dart';

import 'sign_in_or_up_viewmodel.dart';

class SignInOrUpView extends StatelessWidget {
  final bool signUp;

  const SignInOrUpView({Key? key, required this.signUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInOrUpViewModel>.reactive(
      builder: (context, model, child) => _builder(model),
      viewModelBuilder: () => SignInOrUpViewModel(signUp),
    );
  }

  Scaffold _builder(SignInOrUpViewModel model) {
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
                model.signingUp ? 'Sign up' : 'Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Wrap(children: [
                Text(
                  model.signingUp
                      ? 'Already have an account? '
                      : 'Dont have an account? ',
                  style: TextStyle(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => model.toggleSignUp(),
                  child: Text(
                    model.signingUp ? 'Sign in' : 'Sign up',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 72),
              MyTextField(
                controller: model.emailController,
                hintText: 'Email',
                error: model.inputErrors['email'],
              ),
              SizedBox(height: 28),
              MyTextField(
                controller: model.passwordController,
                hintText: 'Password',
                obscureText: true,
                error: model.inputErrors['password'],
              ),
              SizedBox(height: 28),
              if (model.signingUp)
                MyTextField(
                  controller: model.confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                  error: model.inputErrors['confirmPassword'],
                ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: MyButton(
                  text: 'Confirm',
                  onPressed: model.confirm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
