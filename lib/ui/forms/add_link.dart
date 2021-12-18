import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked_services/stacked_services.dart';

final _materialApi = locator<MaterialApiService>();
final _userStore = locator<UserStore>();
final _userApi = locator<UserApiService>();
final _navigationService = locator<NavigationService>();

FlexibleFormPageArguments addLinkForm(
        Function() notifyListeners, Topic topic) =>
    FlexibleFormPageArguments(
      title: 'Add material by url',
      subtitle: 'Add to topic "${topic.title}"',
      fieldsToWidgets: {'title': 'TextField:Title', 'link': 'TextField:Link'},
      onSubmit: (inputs, setErrors) async {
        final errors = {
          if (inputs['title'].isEmpty) 'title': 'Give this material a title',
          if (inputs['link'].isEmpty)
            'link': 'Please enter a link to the study material',
        };
        if (errors.isNotEmpty) {
          setErrors(errors);
          return;
        }

        final material = await _materialApi.addLink(
          _userStore.currentUser.id,
          topic.moduleId,
          topic.id,
          inputs['title'],
          inputs['link'],
        );
        topic.materialIds.add(material.id);
        notifyListeners();
        setErrors({});
        _navigationService.back();
      },
    );
