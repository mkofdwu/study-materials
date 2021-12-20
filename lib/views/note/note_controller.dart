import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  final Future Function(String, String) _saveNote;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  NoteController(String title, String content, this._saveNote) {
    titleController.text = title;
    contentController.text = content;
  }

  Future<void> saveNote() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Empty title', 'Please enter a title for your note');
      return;
    }
    await _saveNote(titleController.text, contentController.text);
    Get.snackbar('Success', 'Your note has been saved successfully');
  }

  Future<void> saveAndQuit() async {
    String title = titleController.text;
    if (title.isEmpty && contentController.text.isEmpty) {
      Get.back();
    } else {
      if (title.isEmpty) {
        // note with content but no title
        title = 'Untitled Note';
      }
      await _saveNote(title, contentController.text);
      Get.back();
    }
  }
}
