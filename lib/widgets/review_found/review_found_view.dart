import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/found_material.dart';
import 'package:hackathon_study_materials/widgets/list_tile.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';

import 'review_found_controller.dart';

class ReviewFoundView extends StatelessWidget {
  final Map<String, List<FoundMaterial>> topicToFound;
  final Function(dynamic) onValueChanged;

  const ReviewFoundView({
    Key? key,
    required this.topicToFound,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewFoundController>(
      init: ReviewFoundController(topicToFound, onValueChanged),
      builder: (controller) => SingleChildScrollView(
        child: topicToFound.length == 1
            ? _buildFoundMaterialsList(
                controller,
                topicToFound.values.first,
                null,
              )
            // dont show topic title if is only one
            : Column(
                children: topicToFound
                    .map(
                      (topicName, foundMaterials) => MapEntry(
                        topicName,
                        _buildFoundMaterialsList(
                          controller,
                          foundMaterials,
                          topicName,
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildFoundMaterialsList(
    ReviewFoundController controller,
    List<FoundMaterial> foundMaterials,
    String? topicName,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (topicName != null
                ? <Widget>[
                    Text(
                      topicName,
                      style: TextStyle(
                        color: Get.theme.primaryColor.withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),
                  ]
                : <Widget>[]) +
            foundMaterials
                .map((found) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () => controller.toggleSelected(found),
                        child: MyListTile(
                          title: found.title,
                          subtitle: found.siteName,
                          iconData: getMaterialIcon(found.siteName),
                          suffixIcons: found.selected
                              ? {
                                  FluentIcons.checkmark_20_regular: () =>
                                      controller.toggleSelected(found)
                                }
                              : {},
                          onPressed: () => controller.toggleSelected(found),
                        ),
                      ),
                    ))
                .toList() +
            [SizedBox(height: 32)],
      );
}
