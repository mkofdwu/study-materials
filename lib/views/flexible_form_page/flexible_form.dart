class FlexibleForm {
  final String title;
  final String? subtitle;
  // field: type of field
  // type of field = 'TextField:<label>' or function that returns a widget
  // and takes in a parameter function onValueChanged that it calls
  // when the value is updated
  final Map<String, dynamic> fieldsToWidgets;
  final Map<String, String>? textDefaultValues; // only for TextFields
  final void Function(
    Map<String, dynamic> inputs,
    Function(Map<String, String>) setInputErrors,
  ) onSubmit;

  FlexibleForm({
    required this.title,
    this.subtitle,
    required this.fieldsToWidgets,
    required this.onSubmit,
    this.textDefaultValues,
  });
}
