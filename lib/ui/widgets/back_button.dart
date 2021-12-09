import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:stacked_services/stacked_services.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().back();
      },
      child: Row(
        children: const [
          Icon(FluentIcons.chevron_left_20_regular),
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
