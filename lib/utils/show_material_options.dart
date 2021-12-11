import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> showMaterialOptions(
  List<Topic> moduleTopics, // possible topics to switch between
  Topic parentTopic,
  StudyMaterial material,
  Function notifyListeners,
) async {
  final _bottomSheetService = locator<BottomSheetService>();
  final _moduleApi = locator<ModuleApiService>();

  final response = await _bottomSheetService.showCustomSheet(
    variant: BottomSheetType.choice,
    title: material.title,
    data: [
      material.pinned ? 'Unpin material' : 'Pin material',
      'Edit details',
      'Delete material',
    ],
  );

  if (response != null && response.confirmed) {
    switch (response.data) {
      case 'Pin material':
      case 'Unpin material':
        material.pinned = !material.pinned;
        await _moduleApi.editMaterial(material);
        notifyListeners();
        break;
      case 'Edit details':
        final _navigationService = locator<NavigationService>();
        _navigationService.navigateTo(
          Routes.flexibleFormPage,
          arguments: FlexibleFormPageArguments(
            title: 'Edit material details',
            subtitle: material.title,
            fieldsToWidgets: {
              'title': 'TextField:Title',
              'topicId': (onValueChanged) => DropdownButton<String>(
                    value: material.topicId,
                    items: moduleTopics
                        .map((topic) => DropdownMenuItem(
                              value: topic.id,
                              child: Text(topic.title),
                            ))
                        .toList(),
                    onChanged: onValueChanged,
                  ),
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

              if (inputs['topicId'] != material.topicId) {
                // move from one topic to another
                // fixme nato ehsnuaoeunthasonteu h
                final fromTopic = moduleTopics
                    .firstWhere((topic) => topic.id == material.topicId);
                final toTopic = moduleTopics
                    .firstWhere((topic) => topic.id == inputs['topicId']);
                fromTopic.materialIds.remove(material.id);
                toTopic.materialIds.add(material.id);
                await _moduleApi.editTopic(fromTopic);
                await _moduleApi.editTopic(toTopic);

                material.topicId = inputs['topicId'];
              }

              material.title = inputs['title'];
              material.type = inputs['type'];
              material.url = inputs['url'];
              await _moduleApi.editMaterial(material);
              notifyListeners();
              _navigationService.back();
            },
          ),
        );
        break;
      case 'Delete material':
        final response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.yesno,
          title: 'Delete material?',
          description:
              "The material '${material.title}' will be from your library. This action is irriversible!",
        );
        if (response != null && response.confirmed) {
          parentTopic.materialIds.remove(material.id);
          await _moduleApi.deleteMaterial(material);
          notifyListeners();
        }
        break;
    }
  }
}

Future<void> _confirmDeleteMaterial() async {
  final _bottomSheetService = locator<BottomSheetService>();
}
