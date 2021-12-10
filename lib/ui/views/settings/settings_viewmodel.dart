import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _userApi = locator<UserApiService>();

  List<ResourceSite> get resourceSites => _userStore.currentUser.resourceSites;
  int get numResults => _userStore.currentUser.numResults;

  void addResourceSite() {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: FlexibleFormPageArguments(
        title: 'Add resource site',
        fieldsToWidgets: {
          'title': 'TextField:Title',
          'siteUrl': 'TextField:Site url',
          'queryUrl': 'TextField:Query url',
        },
        onSubmit: (inputs, setErrors, back) async {
          final errors = {
            if (inputs['title'].isEmpty) 'title': 'Please enter a title',
            if (inputs['siteUrl'].isEmpty)
              'siteUrl': 'Please enter the site url',
          };
          if (errors.isNotEmpty) {
            setErrors(errors);
            return;
          }

          _userStore.currentUser.resourceSites
              .add(ResourceSite.fromMap(inputs));
          // could be more efficient:
          await _userApi.setUserData(_userStore.currentUser);
          notifyListeners();
          back();
        },
      ),
    );
  }

  void editResourceSite(ResourceSite resourceSite) {
    _navigationService.navigateTo(
      Routes.flexibleFormPage,
      arguments: FlexibleFormPageArguments(
        title: 'Edit resource site',
        fieldsToWidgets: {
          'title': 'TextField:Title',
          'siteUrl': 'TextField:Site url',
          'queryUrl': 'TextField:Query url',
        },
        textDefaultValues: {
          'title': resourceSite.title,
          'siteUrl': resourceSite.siteUrl,
          'queryUrl': resourceSite.queryUrl ?? ''
        },
        onSubmit: (inputs, setErrors, back) async {
          final errors = {
            if (inputs['title'].isEmpty) 'title': 'Please enter a title',
            if (inputs['siteUrl'].isEmpty)
              'siteUrl': 'Please enter the site url',
          };
          if (errors.isNotEmpty) {
            setErrors(errors);
            return;
          }

          final updatedResource = ResourceSite.fromMap(inputs);
          final index =
              _userStore.currentUser.resourceSites.indexOf(resourceSite);
          _userStore.currentUser.resourceSites[index] = updatedResource;
          // could be more efficient:
          await _userApi.setUserData(_userStore.currentUser);
          notifyListeners(); // update display in this page
          back();
        },
      ),
    );
  }

  Future<void> removeResourceSite(ResourceSite resourceSite) async {
    // TODO: ask confirm
    _userStore.currentUser.resourceSites.remove(resourceSite);
    await _userApi.setUserData(_userStore.currentUser);
    notifyListeners();
  }

  Future<void> onChangeNumResults(int? newNumResults) async {
    if (newNumResults != null) {
      _userStore.currentUser.numResults = newNumResults;
      // could be more efficient:
      await _userApi.setUserData(_userStore.currentUser);
      notifyListeners();
    }
  }

  void goToProfile() {}

  void signOut() {
    _authService.signOut();
    _navigationService.clearStackAndShow(Routes.welcomeView);
    _snackbarService.showSnackbar(
      title: 'Success',
      message: 'Signed out successfully',
    );
  }
}
