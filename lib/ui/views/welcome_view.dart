import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:stacked_services/stacked_services.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  void _signIn({bool signUp = false}) {
    locator<NavigationService>().navigateTo(
      Routes.signInOrUpView,
      arguments: SignInOrUpViewArguments(signUp: signUp),
    );
  }

  void _goToAbout() {
    locator<NavigationService>().navigateTo(Routes.aboutView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/undraw_studying_re_deca.png',
                width: 240,
              ),
              const SizedBox(height: 40),
              const Text(
                'Materials',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 240,
                child: Text(
                  'Find, track and organise your study materials and lecture notes.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              MyButton(
                text: 'Sign up',
                onPressed: () => _signIn(signUp: true),
              ),
              const SizedBox(height: 16),
              MyButton(
                text: 'Sign in',
                isPrimary: false,
                onPressed: () => _signIn(signUp: false),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version 0.1',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: _goToAbout,
                    child: Text(
                      'About',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => showLicensePage(context: context),
                    child: Text(
                      'Licenses',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
