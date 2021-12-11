import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class FlexibleFormPageViewModel extends BaseViewModel {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _customWidgetValues = {};
  Map<String, String> inputErrors = {};
  bool isLoading = false;

  final void Function(
    Map<String, dynamic> inputs,
    Function(Map<String, String>) setInputErrors,
  ) _submit;
  final Map<String, String> _textDefaultValues;

  FlexibleFormPageViewModel(this._submit, this._textDefaultValues);

  TextEditingController createController(String field) {
    if (_controllers.containsKey(field)) {
      return _controllers[field]!;
    }
    final controller = TextEditingController(text: _textDefaultValues[field]);
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
    notifyListeners();
    _submit(allInputs, (errors) {
      inputErrors = errors;
      isLoading = false;
      notifyListeners();
    });
  }
}
