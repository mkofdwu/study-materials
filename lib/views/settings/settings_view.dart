import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (controller) => SingleChildScrollView(
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
              _buildResourceSitesView(controller),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of top results',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  DropdownButton<int>(
                    value: controller.numResults,
                    items: List<int>.generate(20, (i) => i + 1)
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                    onChanged: controller.onChangeNumResults,
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildActionSetting('Connect to MS Teams', () {}),
              SizedBox(height: 20),
              _buildActionSetting('Profile', controller.goToProfile),
              SizedBox(height: 20),
              _buildActionSetting(
                controller.isDarkMode ? 'Light mode' : 'Dark mode',
                controller.toggleDarkMode,
              ),
              SizedBox(height: 20),
              _buildActionSetting('Sign out', controller.signOut),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceSitesView(SettingsController controller) => Column(
        children: [
          _buildActionSetting(
            'Resource sites',
            controller.addResourceSite,
            iconData: FluentIcons.add_20_filled,
          ),
          SizedBox(height: 24),
          ...controller.resourceSites
              .map(
                (resourceSite) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => controller.editResourceSite(resourceSite),
                        child: Text(
                          resourceSite.title,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            controller.removeResourceSite(resourceSite),
                        child: Icon(FluentIcons.dismiss_12_regular, size: 12),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
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
