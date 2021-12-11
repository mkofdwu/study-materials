import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';
import 'package:hackathon_study_materials/utils/open_material.dart';
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
      builder: (context, model, child) => _builder(model),
      viewModelBuilder: () => TopicViewModel(topic, parentModule),
    );
  }

  Widget _builder(TopicViewModel model) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(FluentIcons.add_20_regular),
          backgroundColor: Palette.darkGrey,
          onPressed: model.goToFindMaterial,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBackButton(),
                  SizedBox(height: 80),
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
                        child: Icon(FluentIcons.filter_20_regular, size: 20),
                        onPressed: model.goToFilter,
                      ),
                      SizedBox(width: 16),
                      PressedFeedback(
                        child: Icon(FluentIcons.more_vertical_20_regular,
                            size: 20),
                        onPressed: model.showTopicOptions,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Materials',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28),
                  FutureBuilder<List<StudyMaterial>>(
                    future: model.getMaterials(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Palette.darkGrey,
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: snapshot.data!
                            .map(
                              (material) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MyListTile(
                                  title: material.title,
                                  subtitle: material.type,
                                  iconData: getMaterialIcon(material.type),
                                  suffixIcons: {
                                    if (material.pinned)
                                      FluentIcons.pin_20_filled: () {},
                                    FluentIcons.more_vertical_20_regular: () =>
                                        showMaterialOptions(
                                          parentModule.topics,
                                          topic,
                                          material,
                                          model.notifyListeners,
                                        ),
                                  },
                                  onPressed: () => openMaterial(material),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
