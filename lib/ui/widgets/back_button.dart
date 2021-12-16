import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:stacked_services/stacked_services.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedFeedback(
      onPressed: () {
        locator<NavigationService>().back();
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
