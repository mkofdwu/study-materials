import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/widgets/back_button.dart';
import 'package:hackathon_study_materials/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/widgets/pressed_feedback.dart';
import 'package:hackathon_study_materials/utils/show_material_options.dart';

import 'topic_controller.dart';

class TopicView extends StatelessWidget {
  final Module parentModule;
  final Topic topic;

  const TopicView({Key? key, required this.parentModule, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopicController>(
      init: TopicController(topic, parentModule),
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            FluentIcons.add_20_regular,
            color: Get.theme.backgroundColor,
          ),
          backgroundColor: Get.theme.colorScheme.secondary,
          onPressed: controller.goToFindMaterial,
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
                      onPressed: controller.goToAddLink,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child: Icon(FluentIcons.note_20_regular, size: 20),
                      onPressed: controller.goToAddNote,
                    ),
                    Spacer(),
                    PressedFeedback(
                      child: Icon(FluentIcons.search_20_regular, size: 20),
                      onPressed: controller.goToSearch,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child: Icon(
                        controller.filterByType == null
                            ? FluentIcons.filter_20_regular
                            : FluentIcons.filter_dismiss_20_filled,
                        size: 20,
                      ),
                      onPressed: controller.setFilter,
                    ),
                    SizedBox(width: 16),
                    PressedFeedback(
                      child:
                          Icon(FluentIcons.more_vertical_20_regular, size: 20),
                      onPressed: controller.showTopicOptions,
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
                            color: Get.theme.primaryColor.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 28),
                        MaterialListView(
                          future:
                              controller.getMaterials(controller.filterByType),
                          getSubtitle: (material) => material.type,
                          onShowOptions: (material) => showMaterialOptions(
                            controller.update,
                            parentModule.topics,
                            material,
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
      ),
    );
  }
}
