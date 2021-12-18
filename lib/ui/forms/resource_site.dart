import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked_services/stacked_services.dart';

final _userStore = locator<UserStore>();
final _userApi = locator<UserApiService>();
final _navigationService = locator<NavigationService>();

FlexibleFormPageArguments resourceSiteForm(
  Function() notifyListeners, {
  ResourceSite? resourceSite,
}) =>
    FlexibleFormPageArguments(
      title: (resourceSite == null ? 'Add' : 'Edit') + ' resource site',
      fieldsToWidgets: {
        'title': 'TextField:Title',
        'siteUrl': 'TextField:Site url',
        'queryUrl': 'TextField:Query url (optional)',
      },
      textDefaultValues: {
        'title': resourceSite?.title ?? '',
        'siteUrl': resourceSite?.siteUrl ?? '',
        'queryUrl': resourceSite?.queryUrl ?? '',
      },
      onSubmit: (inputs, setErrors) async {
        final errors = {
          if (inputs['title'].isEmpty) 'title': 'Please enter a title',
          if (inputs['siteUrl'].isEmpty)
            'siteUrl': 'Please enter the site url'
          else if (!(inputs['siteUrl'] as String).isURL)
            'siteUrl': 'This is not a valid url',
        };
        if (errors.isNotEmpty) {
          setErrors(errors);
          return;
        }

        if (resourceSite == null) {
          // add new resource
          _userStore.currentUser.resourceSites
              .add(ResourceSite.fromMap(inputs));
        } else {
          // edit resource
          final updatedResource = ResourceSite.fromMap(inputs);
          final index =
              _userStore.currentUser.resourceSites.indexOf(resourceSite);
          _userStore.currentUser.resourceSites[index] = updatedResource;
        }
        // could be more efficient:
        await _userApi.setUserData(_userStore.currentUser);
        notifyListeners();
        setErrors({});
        _navigationService.back();
      },
    );
