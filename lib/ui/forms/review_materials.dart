import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/widgets/review_found/review_found_view.dart';
import 'package:stacked_services/stacked_services.dart';

final _moduleApi = locator<ModuleApiService>();
final _materialApi = locator<MaterialApiService>();
final _userStore = locator<UserStore>();
final _navigationService = locator<NavigationService>();

FlexibleFormPageArguments reviewMaterialsForm(
  Function() notifyListeners,
  Map<String, List<FoundMaterial>> topicToFound, {
  // used by add topic(s) form
  Module? module,
  // used by add more materials form
  Topic? addToTopic,
}) =>
    FlexibleFormPageArguments(
      title: 'Review materials',
      subtitle:
          "We've gathered some study material you may be interested in. Choose which to add to ${addToTopic?.title ?? module!.title}",
      fieldsToWidgets: {
        'materials': (onValueChanged) => ReviewFoundView(
              topicToFound: topicToFound,
              onValueChanged: onValueChanged,
            ),
      },
      onSubmit: (inputs, setErrors) async {
        if (addToTopic == null) {
          // create topic, add materials
          assert(module != null);
          for (final topicName in inputs['materials'].keys) {
            final topic = await _moduleApi.addTopic(module!.id, topicName);
            for (final found in inputs['materials'][topicName]) {
              if (found.selected) {
                final material = await _materialApi.addFoundMaterial(
                  _userStore.currentUser.id,
                  module.id,
                  topic.id,
                  found,
                );
                topic.materialIds.add(material.id);
              }
            }
            module.topics.add(topic);
          }
        } else {
          assert(topicToFound.length == 1);
          assert(topicToFound.containsKey(addToTopic.title));
          for (final found in inputs['materials'][addToTopic.title]) {
            if (found.selected) {
              final material = await _materialApi.addFoundMaterial(
                _userStore.currentUser.id,
                addToTopic.moduleId,
                addToTopic.id,
                found,
              );
              addToTopic.materialIds.add(material.id);
            }
          }
        }
        notifyListeners();
        setErrors({});
        _navigationService.back();
        _navigationService.back();
      },
    );
