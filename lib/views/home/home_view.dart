import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/views/home/home_controller.dart';
import 'package:hackathon_study_materials/views/modules/modules_view.dart';
import 'package:hackathon_study_materials/views/settings/settings_view.dart';
import 'package:hackathon_study_materials/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/utils/format_date_time.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        body: SafeArea(child: _buildBody(controller)),
        // a bit awkward to put it here
        floatingActionButton: controller.currentTab == 1
            ? FloatingActionButton(
                child: Icon(
                  FluentIcons.add_20_regular,
                  color: Get.theme.backgroundColor,
                ),
                backgroundColor: Get.theme.colorScheme.secondary,
                onPressed: controller.goToAddModule,
              )
            : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Get.theme.primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentTab,
            onTap: controller.onSelectTab,
            elevation: 0,
            selectedItemColor: Get.theme.primaryColor,
            unselectedItemColor: Get.theme.primaryColor.withOpacity(0.6),
            selectedFontSize: 12,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            enableFeedback: false,
            backgroundColor: Get.theme.backgroundColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FluentIcons.home_20_regular),
                activeIcon: Icon(FluentIcons.home_20_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(FluentIcons.text_bullet_list_ltr_20_regular),
                activeIcon: Icon(FluentIcons.text_bullet_list_ltr_20_filled),
                label: 'Modules',
              ),
              BottomNavigationBarItem(
                icon: Icon(FluentIcons.settings_20_regular),
                activeIcon: Icon(FluentIcons.settings_20_filled),
                label: 'Settings',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HomeController controller) {
    switch (controller.currentTab) {
      case 0:
        return _buildHomeView(controller);
      case 1:
        return ModulesView();
      case 2:
        return SettingsView();
      default:
        return SizedBox.shrink();
    }
  }

// duplication
  Widget _buildHomeView(HomeController controller) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              Text(
                'Study',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Materials',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 28),
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Get.theme.primaryColorLight,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintText: 'Quick search',
                  hintStyle: TextStyle(
                    color: Get.theme.primaryColor.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    FluentIcons.search_20_regular,
                    color: Get.theme.primaryColor,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 40, minHeight: 20),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                cursorColor: Get.theme.primaryColor,
                // onChanged: (value) => controller.notifyListeners(),
              ),
              SizedBox(height: 60),
              if (controller.searchController.text.isEmpty)
                Text(
                  'Recently uploaded',
                  style: TextStyle(
                    color: Get.theme.primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (controller.searchController.text.isEmpty)
                SizedBox(height: 32),
              MaterialListView(
                future: controller.searchController.text.isEmpty
                    ? controller.getRecentMaterials()
                    : controller
                        .getSearchResults(controller.searchController.text),
                getSubtitle: (material) => formatDateTime(material.dateCreated),
                showPins: false,
              ),
            ],
          ),
        ),
      );
}
