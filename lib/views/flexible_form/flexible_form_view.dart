import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/back_button.dart';
import 'package:hackathon_study_materials/widgets/button.dart';
import 'package:hackathon_study_materials/widgets/text_field.dart';

import 'flexible_form.dart';
import 'flexible_form_controller.dart';

class FlexibleFormView extends StatelessWidget {
  final FlexibleForm form;

  const FlexibleFormView({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlexibleFormController>(
      init: FlexibleFormController(form),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 32, right: 32),
          child: MyButton(
            text: 'Submit',
            onPressed: controller.submit,
            isLoading: controller.isLoading,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48),
                MyBackButton(),
                SizedBox(height: 56),
                Text(
                  form.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                if (form.subtitle != null)
                  Text(
                    form.subtitle!,
                    style: TextStyle(
                      color: Get.theme.primaryColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                SizedBox(height: 72),
                // would a listview be better?
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _fieldWidgetsToChildren(controller)
                          .map(
                            (widget) => Padding(
                              padding: const EdgeInsets.only(bottom: 28),
                              child: widget,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _fieldWidgetsToChildren(FlexibleFormController controller) =>
      form.fieldsToWidgets.keys.map((field) {
        final widget = form.fieldsToWidgets[field];
        if (widget is String && widget.startsWith('TextField:')) {
          return MyTextField(
            controller: controller.createController(field),
            hintText:
                widget.substring(10), // label, e.g. TextField:Confirm password
            error: controller.inputErrors[field],
          );
        }
        widget as Widget Function(Function onValueChanged);
        return widget(controller.createValueChangedHandler(field));
      }).toList();
}
