import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'flexible_form.dart';

class FlexibleFormController extends GetxController {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _customWidgetValues = {};
  Map<String, String> inputErrors = {};
  bool isLoading = false;

  final FlexibleForm _form;

  FlexibleFormController(this._form);

  TextEditingController createController(String field) {
    if (_controllers.containsKey(field)) {
      return _controllers[field]!;
    }
    final controller =
        TextEditingController(text: _form.textDefaultValues?[field]);
    _controllers[field] = controller;
    return controller;
  }

  Function(dynamic) createValueChangedHandler(String field) {
    return (newValue) {
      _customWidgetValues[field] = newValue;
    };
  }

  void submit() {
    final allInputs = _controllers.map<String, dynamic>(
        (field, controller) => MapEntry(field, controller.text));
    allInputs.addAll(_customWidgetValues);
    isLoading = true;
    update();
    _form.onSubmit(allInputs, (errors) {
      inputErrors = errors;
      isLoading = false;
      update();
    });
  }
}
