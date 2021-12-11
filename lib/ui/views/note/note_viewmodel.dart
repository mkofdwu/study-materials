import 'package:flutter/cupertino.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NoteViewModel extends BaseViewModel {
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  final Future Function(String, String) _saveNote;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  NoteViewModel(String title, String content, this._saveNote) {
    titleController.text = title;
    contentController.text = content;
  }

  Future<void> saveNote() async {
    if (titleController.text.isEmpty) {
      _snackbarService.showSnackbar(
        title: 'Empty title',
        message: 'Please enter a title for your note',
      );
      return;
    }
    await _saveNote(titleController.text, contentController.text);
    _snackbarService.showSnackbar(
      title: 'Success',
      message: 'Your note has been saved successfully',
    );
  }

  Future<void> saveAndQuit() async {
    String title = titleController.text;
    if (title.isEmpty && contentController.text.isEmpty) {
      _navigationService.back();
    } else {
      if (title.isEmpty) {
        // note with content but no title
        title = 'Untitled Note';
      }
      await _saveNote(title, contentController.text);
      _navigationService.back();
    }
  }
}
