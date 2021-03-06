import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/services/api/microsoft_teams_service.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/ui/forms/resource_site.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SettingsViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _userApi = locator<UserApiService>();
  final _microsoftTeamsService = locator<MicrosoftTeamsService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _themeService = locator<ThemeService>();

  List<ResourceSite> get resourceSites => _userStore.currentUser.resourceSites;
  int get numResults => _userStore.currentUser.numResults;

  void addResourceSite() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: resourceSiteForm(notifyListeners),
    );
  }

  void editResourceSite(ResourceSite resourceSite) {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: resourceSiteForm(notifyListeners, resourceSite: resourceSite),
    );
  }

  Future<void> removeResourceSite(ResourceSite resourceSite) async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.yesno,
      title: 'Remove resource site?',
      description:
          "You'll no longer search for study materials on '${resourceSite.title}' (${resourceSite.siteUrl}).",
    );
    if (response != null && response.confirmed) {
      _userStore.currentUser.resourceSites.remove(resourceSite);
      await _userApi.setUserData(_userStore.currentUser);
      notifyListeners();
    }
  }

  Future<void> onChangeNumResults(int? newNumResults) async {
    if (newNumResults != null) {
      _userStore.currentUser.numResults = newNumResults;
      // could be more efficient:
      await _userApi.setUserData(_userStore.currentUser);
      notifyListeners();
    }
  }

  bool get connectedToTeams => _microsoftTeamsService.isConnected;

  void toggleConnectToTeams() {
    if (connectedToTeams) {
      _microsoftTeamsService.disconnect();
    } else {
      _microsoftTeamsService.connect();
    }
    notifyListeners();
  }

  void goToProfile() {}

  bool get isDarkMode => _themeService.isDarkMode;

  void toggleDarkMode() {
    _themeService.toggleDarkLightTheme();
    notifyListeners();
  }

  Future<void> signOut() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.yesno,
      title: 'Sign out?',
      description: 'Are you sure you want to sign out of your account?',
    );
    if (response != null && response.confirmed) {
      _authService.signOut();
      _navigationService.clearStackAndShow(Routes.welcomeView);
      _snackbarService.showSnackbar(
        title: 'Success',
        message: 'Signed out successfully',
      );
    }
  }
}
