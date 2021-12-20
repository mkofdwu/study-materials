import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/services/db_module_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/widgets/choice_bottom_sheet.dart';
import 'package:hackathon_study_materials/widgets/input_bottom_sheet.dart';
import 'package:hackathon_study_materials/widgets/yesno_bottom_sheet.dart';

Future<void> showModuleOptions(
  Function update,
  Module module, {
  bool backOnDelete = false,
}) async {
  final _authService = Get.find<AuthService>();
  final _moduleApi = Get.find<DbModuleService>();

  final choice = await Get.bottomSheet(ChoiceBottomSheet(
    title: 'Module options',
    choices: const ['Connect to team', 'Rename module', 'Delete module'],
  ));
  if (choice != null) {
    switch (choice) {
      case 'Connect to team':
        // TODO (needs a verified publisher)
        break;
      case 'Rename module':
        final newTitle = await Get.bottomSheet(InputBottomSheet(
          title: 'Rename module',
          defaultText: module.title,
        ));
        if (newTitle != null) {
          module.title = newTitle;
          await _moduleApi.editModule(module);
          update();
        }
        break;
      case 'Delete module':
        final confirmed = await Get.bottomSheet(YesNoBottomSheet(
          title: 'Delete module?',
          subtitle:
              "The module '${module.title}' will be deleted, along with all its topics. This action is irriversible!",
        ));
        if (confirmed) {
          _authService.currentUser.moduleIds.remove(module.id);
          await _moduleApi.deleteModule(module);
          update();
          if (backOnDelete) Get.back();
          Get.snackbar('Success', '${module.title} has been deleted.');
        }
        break;
    }
  }
}
