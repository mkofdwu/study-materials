import 'package:flutter/cupertino.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FlexibleFormPageViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _customWidgetValues = {};
  Map<String, String> inputErrors = {};

  final Future<Map<String, String>> Function(Map<String, dynamic>) _submit;
  final Map<String, String> _textDefaultValues;

  FlexibleFormPageViewModel(this._submit, this._textDefaultValues);

  TextEditingController createController(String field) {
    final controller = TextEditingController(text: _textDefaultValues[field]);
    _controllers[field] = controller;
    return controller;
  }

  Function(dynamic) createValueChangedHandler(String field) {
    return (newValue) {
      _customWidgetValues[field] = newValue;
    };
  }

  Future<void> submit() async {
    final allInputs = _controllers.map<String, dynamic>(
        (field, controller) => MapEntry(field, controller.text));
    allInputs.addAll(_customWidgetValues);
    final errors = await _submit(allInputs);
    if (errors.isEmpty) {
      _navigationService.back();
    } else {
      inputErrors = errors;
    }
  }
}
