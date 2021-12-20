import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/button.dart';

class YesNoBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  const YesNoBottomSheet({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, top: 24, right: 30, bottom: 30),
      decoration: BoxDecoration(
        color: Get.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(color: Get.theme.primaryColor.withOpacity(0.6)),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: 'Confirm',
                  fillWidth: true,
                  onPressed: () => Get.back(result: true),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: MyButton(
                  text: 'Cancel',
                  isPrimary: false,
                  fillWidth: true,
                  onPressed: () => Get.back(result: false),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
