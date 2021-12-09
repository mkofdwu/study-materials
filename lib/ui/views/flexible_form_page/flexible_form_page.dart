import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:hackathon_study_materials/ui/widgets/text_field.dart';
import 'package:stacked/stacked.dart';

import 'flexible_form_page_viewmodel.dart';

class FlexibleFormPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  // field: type of field
  // type of field = 'TextField:<label>' or function that returns a widget
  // and takes in a parameter function onValueChanged that it calls
  // when the value is updated
  final Map<String, dynamic> fieldsToWidgets;
  final Map<String, String>? textDefaultValues; // only for TextFields
  final Future<Map<String, String>> Function(Map<String, dynamic>)
      onSubmit; // field: value

  const FlexibleFormPage({
    Key? key,
    required this.title,
    this.subtitle,
    required this.fieldsToWidgets,
    required this.onSubmit,
    this.textDefaultValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlexibleFormPageViewModel>.reactive(
      builder: (context, model, child) => _builder(model),
      viewModelBuilder: () =>
          FlexibleFormPageViewModel(onSubmit, textDefaultValues ?? {}),
    );
  }

  Scaffold _builder(FlexibleFormPageViewModel model) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyBackButton(),
              SizedBox(height: 56),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              SizedBox(height: 72),
              // would a listview be better?
              SingleChildScrollView(
                child: Column(
                  children: _fieldWidgetsToChildren(model)
                      .map(
                        (widget) => Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: widget,
                        ),
                      )
                      .toList(),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: MyButton(
                  text: 'Submit',
                  onPressed: model.submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _fieldWidgetsToChildren(FlexibleFormPageViewModel model) =>
      fieldsToWidgets.keys.map((field) {
        final widget = fieldsToWidgets[field];
        if (widget is String && widget.startsWith('TextField:')) {
          return MyTextField(
            controller: model.createController(field),
            hintText:
                widget.substring(10), // label, e.g. TextField:Confirm password
            error: model.inputErrors[field],
          );
        }
        widget as Widget Function(Function onValueChanged);
        return widget(model.createValueChangedHandler(field));
      }).toList();
}
