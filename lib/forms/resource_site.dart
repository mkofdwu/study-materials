import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/resource_site.dart';
import 'package:hackathon_study_materials/services/db_user_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/views/flexible_form/flexible_form.dart';

final _authService = Get.find<AuthService>();
final _userApi = Get.find<DbUserService>();

FlexibleForm resourceSiteForm(
  Function update, {
  ResourceSite? resourceSite,
}) =>
    FlexibleForm(
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
          _authService.currentUser.resourceSites
              .add(ResourceSite.fromMap(inputs));
        } else {
          // edit resource
          final updatedResource = ResourceSite.fromMap(inputs);
          final index =
              _authService.currentUser.resourceSites.indexOf(resourceSite);
          _authService.currentUser.resourceSites[index] = updatedResource;
        }
        // could be more efficient:
        await _userApi.setUserData(_authService.currentUser);
        update();
        setErrors({});
        Get.back();
      },
    );
