import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/pressed_feedback.dart';

import 'note_controller.dart';

class NoteView extends StatelessWidget {
  final String title;
  final String content;
  final Future Function(String title, String content) saveNote;

  const NoteView({
    Key? key,
    required this.title,
    required this.content,
    required this.saveNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteController>(
      init: NoteController(title, content, saveNote),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: PressedFeedback(
            onPressed: controller.saveAndQuit,
            child: Icon(
              FluentIcons.chevron_left_20_regular,
              color: Get.theme.backgroundColor,
            ),
          ),
          title: TextField(
            controller: controller.titleController,
            style: TextStyle(color: Get.theme.backgroundColor),
            cursorColor: Get.theme.backgroundColor,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Note title',
              hintStyle:
                  TextStyle(color: Get.theme.backgroundColor.withOpacity(0.6)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PressedFeedback(
                onPressed: controller.saveNote,
                child: Icon(
                  FluentIcons.save_20_regular,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          child: TextField(
            controller: controller.contentController,
            cursorColor: Get.theme.primaryColor,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Type something...',
              hintStyle:
                  TextStyle(color: Get.theme.primaryColor.withOpacity(0.2)),
            ),
          ),
        ),
      ),
    );
  }
}
