import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/utils/open_material.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form.dart';
import 'package:hackathon_study_materials/views/flexible_form_page/flexible_form_view.dart';
import 'package:hackathon_study_materials/widgets/choice_bottom_sheet.dart';
import 'package:hackathon_study_materials/widgets/yesno_bottom_sheet.dart';

Future<void> showMaterialOptions(
  Function update,
  List<Topic> moduleTopics, // possible topics to switch between
  StudyMaterial material,
) async {
  final _materialApi = Get.find<DbMaterialService>();

  final choice = await Get.bottomSheet(ChoiceBottomSheet(
    title: material.title,
    choices: [
      material.pinned ? 'Unpin material' : 'Pin material',
      'Move to topic',
      'Edit details',
      'Delete material',
    ],
  ));

  if (choice != null) {
    switch (choice) {
      case 'Pin material':
      case 'Unpin material':
        material.pinned = !material.pinned;
        await _materialApi.editMaterial(material);
        update();
        break;
      case 'Move to topic':
        final choice = await Get.bottomSheet(ChoiceBottomSheet(
          title: 'Move material',
          subtitle: "Select a topic to move '${material.title}' to",
          choices: moduleTopics.map((topic) => topic.title).toList(),
        ));
        if (choice != null) {
          final toTopic =
              moduleTopics.firstWhere((topic) => topic.title == choice);
          await moveToTopicIf(moduleTopics, material, toTopic);
          await _materialApi.editMaterial(material);
          update();
        }
        break;
      case 'Edit details':
        if (material.type == 'Note') {
          openMaterial(material);
        } else {
          Get.to(FlexibleFormView(
            form: FlexibleForm(
              title: 'Edit material details',
              subtitle: material.title,
              fieldsToWidgets: {
                'title': 'TextField:Title',
                'topicId': (onValueChanged) => TopicSelector(
                    moduleTopics: moduleTopics,
                    defaultTopicId: material.topicId,
                    onValueChanged: onValueChanged),
                'type': 'TextField:Material type',
                'url': 'TextField:Url',
              },
              textDefaultValues: {
                'title': material.title,
                'type': material.type,
                'url': material.url,
              },
              onSubmit: (inputs, setErrors) async {
                final errors = {
                  if (inputs['title'].isEmpty) 'title': 'Please enter a title',
                  if (inputs['type'].isEmpty)
                    'type': 'Please enter a material type',
                  if (inputs['url'].isEmpty)
                    'url': 'Please enter the link to the study material',
                };
                if (errors.isNotEmpty) {
                  setErrors(errors);
                  return;
                }

                final toTopic = moduleTopics
                    .firstWhere((topic) => topic.id == inputs['topicId']);
                await moveToTopicIf(moduleTopics, material, toTopic);

                material.title = inputs['title'];
                material.type = inputs['type'];
                material.url = inputs['url'];
                await _materialApi.editMaterial(material);
                update();
                setErrors({});
                Get.back();
              },
            ),
          ));
        }
        break;
      case 'Delete material':
        final confirmed = await Get.bottomSheet(YesNoBottomSheet(
          title: 'Delete material?',
          subtitle:
              "The material '${material.title}' will be from your library. This action is irriversible!",
        ));
        if (confirmed) {
          final parentTopic =
              moduleTopics.firstWhere((topic) => topic.id == material.topicId);
          parentTopic.materialIds.remove(material.id);
          await _materialApi.deleteMaterial(material);
          update();
        }
        break;
    }
  }
}

class TopicSelector extends StatefulWidget {
  final List<Topic> moduleTopics;
  final String? defaultTopicId;
  final Function onValueChanged;

  const TopicSelector(
      {Key? key,
      required this.moduleTopics,
      required this.defaultTopicId,
      required this.onValueChanged})
      : super(key: key);

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.defaultTopicId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic',
          style: TextStyle(
            color: Get.theme.primaryColor.withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedId,
          items: widget.moduleTopics
              .map((topic) => DropdownMenuItem(
                    value: topic.id,
                    child: Text(topic.title),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedId = value;
            });
            widget.onValueChanged(value);
          },
        ),
      ],
    );
  }
}

Future<void> moveToTopicIf(
  List<Topic> moduleTopics,
  StudyMaterial material,
  Topic toTopic,
) async {
  final _moduleApi = Get.find<DbModuleService>();

  if (toTopic.id != material.topicId) {
    // move from one topic to another
    // fixme nato ehsnuaoeunthasonteu h
    final fromTopic =
        moduleTopics.firstWhere((topic) => topic.id == material.topicId);
    fromTopic.materialIds.remove(material.id);
    toTopic.materialIds.add(material.id);
    await _moduleApi.editTopic(fromTopic);
    await _moduleApi.editTopic(toTopic);

    material.topicId = toTopic.id;
  }
}
