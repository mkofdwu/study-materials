import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/button.dart';
import 'package:hackathon_study_materials/widgets/text_field.dart';

class InputBottomSheet extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String defaultText;

  const InputBottomSheet({
    Key? key,
    required this.title,
    this.subtitle,
    this.defaultText = '',
  }) : super(key: key);

  @override
  State<InputBottomSheet> createState() => _InputBottomSheetState();
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  final _textController = TextEditingController();
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.defaultText;
  }

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
            widget.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (widget.subtitle != null) SizedBox(height: 12),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: TextStyle(color: Get.theme.primaryColor.withOpacity(0.6)),
            ),
          SizedBox(height: 30),
          MyTextField(controller: _textController, error: _inputError),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: 'Confirm',
                  fillWidth: true,
                  onPressed: () {
                    if (_textController.text.isEmpty) {
                      setState(() {
                        _inputError = "You can't leave this blank";
                      });
                    } else {
                      Get.back(result: _textController.text);
                    }
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: MyButton(
                  text: 'Cancel',
                  isPrimary: false,
                  fillWidth: true,
                  onPressed: () => Get.back(result: null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
