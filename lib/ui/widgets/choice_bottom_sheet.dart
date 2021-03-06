import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class ChoiceBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ChoiceBottomSheet(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // not sure why this isn't working
        // color: Theme.of(context).backgroundColor,
        // but this works
        color: locator<ThemeService>().isDarkMode
            ? Palette.darkGrey
            : Palette.lightGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                  Text(
                    request.title!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  if (request.description != null) SizedBox(height: 12),
                  if (request.description != null)
                    Text(
                      request.description!,
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6)),
                    ),
                  SizedBox(height: 24),
                ] +
                (request.data as List<String>)
                    .map((choice) => PressedFeedback(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(choice, style: TextStyle(fontSize: 16)),
                          ),
                          onPressed: () => completer(
                              SheetResponse(confirmed: true, data: choice)),
                        ))
                    .toList() +
                [
                  PressedFeedback(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Cancel', style: TextStyle(fontSize: 16)),
                    ),
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                  )
                ],
          ),
        ),
      ),
    );
  }
}
