import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> showModuleOptions(
  Module module,
  Function notifyListeners, {
  bool backOnDelete = false,
}) async {
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  final _userStore = locator<UserStore>();
  final _moduleApi = locator<ModuleApiService>();

  final response = await _bottomSheetService.showCustomSheet(
    variant: BottomSheetType.choice,
    title: 'Module options',
    data: ['Connect to team', 'Rename module', 'Delete module'],
  );
  if (response != null && response.confirmed) {
    switch (response.data) {
      case 'Connect to team':
        // TODO (needs a verified publisher)
        break;
      case 'Rename module':
        final response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.input,
          title: 'Rename module',
          data: module.title, // default value
        );
        if (response != null && response.confirmed) {
          module.title = response.data;
          await _moduleApi.editModule(module);
          notifyListeners();
        }
        break;
      case 'Delete module':
        final response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.yesno,
          title: 'Delete module?',
          description:
              "The module '${module.title}' will be deleted, along with all its topics. This action is irriversible!",
        );
        if (response != null && response.confirmed) {
          _userStore.currentUser.moduleIds.remove(module.id);
          _userStore.currentUser.modules?.remove(module);
          await _moduleApi.deleteModule(module);
          notifyListeners();
          if (backOnDelete) locator<NavigationService>().back();
          _snackbarService.showSnackbar(
            title: 'Success',
            message: '${module.title} has been deleted.',
          );
        }
        break;
    }
  }
}
