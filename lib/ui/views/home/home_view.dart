import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/ui/views/modules/modules_view.dart';
import 'package:hackathon_study_materials/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(child: _buildBody(model.currentTab)),
        // a bit awkward to put it here
        floatingActionButton: model.currentTab == 1
            ? FloatingActionButton(
                child: Icon(FluentIcons.add_20_regular),
                backgroundColor: Palette.darkGrey,
                onPressed: model.goToAddModule,
              )
            : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: model.currentTab,
            onTap: model.onSelectTab,
            elevation: 0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.6),
            selectedFontSize: 12,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            enableFeedback: false,
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
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Widget _buildBody(int currentTab) {
    switch (currentTab) {
      case 0:
        return _buildHomeView();
      case 1:
        return ModulesView();
      case 2:
        return SettingsView();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildHomeView() => Column();
}
