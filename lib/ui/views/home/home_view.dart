import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/views/modules/modules_view.dart';
import 'package:hackathon_study_materials/ui/views/settings/settings_view.dart';
import 'package:hackathon_study_materials/ui/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/utils/format_date_time.dart';
import 'package:stacked/stacked.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(child: _buildBody(context, model)),
        // a bit awkward to put it here
        floatingActionButton: model.currentTab == 1
            ? FloatingActionButton(
                child: Icon(
                  FluentIcons.add_20_regular,
                  color: Theme.of(context).backgroundColor,
                ),
                backgroundColor: Theme.of(context).accentColor,
                onPressed: model.goToAddModule,
              )
            : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: model.currentTab,
            onTap: model.onSelectTab,
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor:
                Theme.of(context).primaryColor.withOpacity(0.6),
            selectedFontSize: 12,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            enableFeedback: false,
            backgroundColor: Theme.of(context).backgroundColor,
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

  Widget _buildBody(BuildContext context, HomeViewModel model) {
    switch (model.currentTab) {
      case 0:
        return _buildHomeView(context, model);
      case 1:
        return ModulesView();
      case 2:
        return SettingsView();
      default:
        return SizedBox.shrink();
    }
  }

// duplication
  Widget _buildHomeView(BuildContext context, HomeViewModel model) =>
      SingleChildScrollView(
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
                controller: model.searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColorLight,
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
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    FluentIcons.search_20_regular,
                    color: Theme.of(context).primaryColor,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 40, minHeight: 20),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                cursorColor: Theme.of(context).primaryColor,
                onChanged: (value) => model.notifyListeners(),
              ),
              SizedBox(height: 60),
              if (model.searchController.text.isEmpty)
                Text(
                  'Recently uploaded',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (model.searchController.text.isEmpty) SizedBox(height: 32),
              MaterialListView(
                future: model.searchController.text.isEmpty
                    ? model.getRecentMaterials()
                    : model.getSearchResults(model.searchController.text),
                getSubtitle: (material) => formatDateTime(material.dateCreated),
                showPins: false,
              ),
            ],
          ),
        ),
      );
}
