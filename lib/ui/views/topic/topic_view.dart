import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:stacked/stacked.dart';

import 'topic_viewmodel.dart';

class TopicView extends StatelessWidget {
  final Topic topic;

  const TopicView({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => TopicViewModel(topic),
    );
  }
}
