import 'package:get/get.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/services/db_user_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form.dart';

final _moduleApi = Get.find<DbModuleService>();
final _authService = Get.find<AuthService>();
final _userApi = Get.find<DbUserService>();

FlexibleForm addModuleForm(Function update) => FlexibleForm(
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
          _authService.currentUser.id,
          inputs['moduleName'],
        );
        _authService.currentUser.moduleIds.add(module.id);
        await _userApi.setUserData(_authService.currentUser);
        update();
        setErrors({});
        Get.back();
      },
    );
