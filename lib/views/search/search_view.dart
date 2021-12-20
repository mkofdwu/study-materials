import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/widgets/pressed_feedback.dart';

import 'search_controller.dart';

class SearchView extends StatelessWidget {
  final Module? module;
  final Topic? topic;

  const SearchView({Key? key, this.module, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      init: SearchController(module, topic),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: Icon(FluentIcons.search_20_regular,
              color: Get.theme.backgroundColor),
          title: TextField(
            controller: controller.searchController,
            style: TextStyle(color: Get.theme.backgroundColor),
            cursorColor: Get.theme.backgroundColor,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search',
              hintStyle:
                  TextStyle(color: Get.theme.backgroundColor.withOpacity(0.6)),
            ),
            // onChanged: (value) => controller.notifyListeners(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PressedFeedback(
                onPressed: controller.dismiss,
                child: Icon(
                  FluentIcons.dismiss_20_regular,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                children: [
                  if (controller.moduleFilter != null)
                    Chip(
                      backgroundColor: Get.theme.primaryColorLight,
                      label: Text(
                        'Module: ' + module!.title,
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                      deleteIconColor: Get.theme.primaryColor,
                      onDeleted: controller.removeModuleFilter,
                    ),
                  if (controller.topicFilter != null)
                    Chip(
                      backgroundColor: Get.theme.primaryColorLight,
                      label: Text(
                        'Topic: ' + topic!.title,
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                      deleteIconColor: Get.theme.primaryColor,
                      onDeleted: controller.removeTopicFilter,
                    ),
                ],
              ),
            ),
            SizedBox(height: 48),
            if (controller.searchController.text.isNotEmpty)
              Expanded(
                child: MaterialListView(
                  future: controller
                      .getSearchResults(controller.searchController.text),
                  getSubtitle: (material) => material.type,
                  onShowOptions: controller.fetchAndShowMaterialOptions,
                  showPins: false,
                  customBuilder: (numResults, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$numResults materials found'),
                        SizedBox(height: 32),
                        Expanded(child: SingleChildScrollView(child: child)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
