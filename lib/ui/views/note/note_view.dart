import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:stacked/stacked.dart';

import 'note_viewmodel.dart';

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
    return ViewModelBuilder<NoteViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: PressedFeedback(
            onPressed: model.saveAndQuit,
            child: Icon(
              FluentIcons.chevron_left_20_regular,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          title: TextField(
            controller: model.titleController,
            style: TextStyle(color: Theme.of(context).backgroundColor),
            cursorColor: Theme.of(context).backgroundColor,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Note title',
              hintStyle: TextStyle(
                  color: Theme.of(context).backgroundColor.withOpacity(0.6)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PressedFeedback(
                onPressed: model.saveNote,
                child: Icon(
                  FluentIcons.save_20_regular,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          child: TextField(
            controller: model.contentController,
            cursorColor: Theme.of(context).primaryColor,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Type something...',
              hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => NoteViewModel(title, content, saveNote),
    );
  }
}
