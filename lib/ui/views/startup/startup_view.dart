import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      builder: _builder,
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) => model.onReady(),
    );
  }

  Widget _builder(
          BuildContext context, StartupViewModel model, Widget? child) =>
      const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
