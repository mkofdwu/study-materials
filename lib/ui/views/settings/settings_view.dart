import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 48),
              _buildResourceSitesView(model),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of top results',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  DropdownButton<int>(
                    value: model.numResults,
                    items: List<int>.generate(20, (i) => i + 1)
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                    onChanged: model.onChangeNumResults,
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildActionSetting(
                model.connectedToTeams
                    ? 'Disconnect from MS Teams'
                    : 'Connect to MS Teams',
                model.toggleConnectToTeams,
              ),
              SizedBox(height: 20),
              _buildActionSetting('Profile', model.goToProfile),
              SizedBox(height: 20),
              _buildActionSetting(
                model.isDarkMode ? 'Light mode' : 'Dark mode',
                model.toggleDarkMode,
              ),
              SizedBox(height: 20),
              _buildActionSetting('Sign out', model.signOut),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SettingsViewModel(),
    );
  }

  Widget _buildResourceSitesView(SettingsViewModel model) => Column(
        children: [
              _buildActionSetting(
                'Resource sites',
                model.addResourceSite,
                iconData: FluentIcons.add_20_filled,
              ),
              SizedBox(height: 24),
            ] +
            model.resourceSites
                .map(
                  (resourceSite) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => model.editResourceSite(resourceSite),
                          child: Text(
                            resourceSite.title,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => model.removeResourceSite(resourceSite),
                          child: Icon(FluentIcons.dismiss_12_regular, size: 12),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      );

  Widget _buildActionSetting(
    String title,
    Function() onTap, {
    IconData iconData = FluentIcons.chevron_right_20_filled,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(iconData),
          ],
        ),
      );
}
