import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ModulesViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();

  List<Module> get modules => _userStore.currentUser.modules!;

  void goToModule(Module module) {
    _navigationService.navigateTo(
      Routes.moduleView,
      arguments: ModuleViewArguments(module: module),
    );
  }
}
