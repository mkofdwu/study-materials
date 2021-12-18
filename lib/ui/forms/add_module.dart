import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked_services/stacked_services.dart';

final _moduleApi = locator<ModuleApiService>();
final _userStore = locator<UserStore>();
final _userApi = locator<UserApiService>();
final _navigationService = locator<NavigationService>();

FlexibleFormPageArguments addModuleForm(Function() notifyListeners) =>
    FlexibleFormPageArguments(
      title: 'Add module',
      fieldsToWidgets: {
        'moduleName': 'TextField:Module name',
      },
      onSubmit: (inputs, setErrors) async {
        if (inputs['moduleName'].isEmpty) {
          setErrors({'moduleName': 'Please enter a name'});
          return;
        }
        final module = await _moduleApi.addModule(
          _userStore.currentUser.id,
          inputs['moduleName'],
        );
        _userStore.currentUser.moduleIds.add(module.id);
        _userStore.currentUser.modules!.add(module);
        await _userApi.setUserData(_userStore.currentUser);
        notifyListeners();
        setErrors({});
        _navigationService.back();
      },
    );
