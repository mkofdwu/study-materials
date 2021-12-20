import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/pressed_feedback.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedFeedback(
      onPressed: () {
        Get.back();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(FluentIcons.chevron_left_20_regular, size: 20),
          SizedBox(width: 4),
          Text(
            'BACK',
            style: TextStyle(fontSize: 14, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}
