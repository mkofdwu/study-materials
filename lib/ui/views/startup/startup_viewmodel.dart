import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  Future<void> onReady() async {
    await _authService.refreshCurrentUser();
    if (_userStore.isSignedIn) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.welcomeView);
    }
  }
}
