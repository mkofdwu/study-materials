import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/back_button.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              MyBackButton(),
              SizedBox(height: 56),
              Text(
                'About study materials',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'By Jia Jie',
                style: TextStyle(
                  color: Get.theme.primaryColor.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Study materials is a simple app to find supplementary learning resources online based on your curriculum, organise notes and keep track of your learning.\n\nMade for appventure hackathon\n\nVersion 0.1',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
