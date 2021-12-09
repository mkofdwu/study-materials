import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'modules_viewmodel.dart';

class ModulesView extends StatelessWidget {
  const ModulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ModulesViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => ModulesViewModel(),
    );
  }
}
