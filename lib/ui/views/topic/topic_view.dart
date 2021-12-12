import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:hackathon_study_materials/utils/show_material_options.dart';
import 'package:stacked/stacked.dart';

import 'topic_viewmodel.dart';

class TopicView extends StatelessWidget {
  final Topic topic;
  final Module parentModule;

  const TopicView({Key? key, required this.topic, required this.parentModule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      builder: (context, model, child) => _builder(context, model),
      viewModelBuilder: () => TopicViewModel(topic, parentModule),
    );
  }

  Widget _builder(BuildContext context, TopicViewModel model) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            FluentIcons.add_20_regular,
            color: Theme.of(context).backgroundColor,
          ),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: model.goToFindMaterial,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48),
                MyBackButton(),
                SizedBox(height: 64),
                Text(
                  topic.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  '${topic.materialIds.length} materials',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    PressedFeedback(
                      child: Icon(FluentIcons.link_20_regular, size: 20),
                      onPressed: model.goToAddLink,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child: Icon(FluentIcons.note_20_regular, size: 20),
                      onPressed: model.goToAddNote,
                    ),
                    Spacer(),
                    PressedFeedback(
                      child: Icon(FluentIcons.search_20_regular, size: 20),
                      onPressed: model.goToSearch,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child: Icon(
                        model.filterByType == null
                            ? FluentIcons.filter_20_regular
                            : FluentIcons.filter_dismiss_20_filled,
                        size: 20,
                      ),
                      onPressed: model.setFilter,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child:
                          Icon(FluentIcons.more_vertical_20_regular, size: 20),
                      onPressed: model.showTopicOptions,
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Materials',
                          style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 28),
                        MaterialListView(
                          future: model.getMaterials(model.filterByType),
                          getSubtitle: (material) => material.type,
                          onShowOptions: (material) => showMaterialOptions(
                            parentModule.topics,
                            material,
                            model.notifyListeners,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
