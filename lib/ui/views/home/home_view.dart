import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/ui/views/modules/modules_view.dart';
import 'package:hackathon_study_materials/ui/views/settings/settings_view.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:hackathon_study_materials/utils/format_date_time.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';
import 'package:hackathon_study_materials/utils/open_material.dart';
import 'package:stacked/stacked.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(child: _buildBody(model)),
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

  Widget _buildBody(HomeViewModel model) {
    switch (model.currentTab) {
      case 0:
        return _buildHomeView(model);
      case 1:
        return ModulesView();
      case 2:
        return SettingsView();
      default:
        return SizedBox.shrink();
    }
  }

// duplication
  Widget _buildHomeView(HomeViewModel model) => SingleChildScrollView(
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.lightGrey,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintText: 'Quick search',
                  prefixIcon: Icon(
                    FluentIcons.search_20_regular,
                    color: Colors.black,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 40, minHeight: 20),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                cursorColor: Colors.black,
              ),
              SizedBox(height: 60),
              Text(
                'Recently uploaded',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32),
              FutureBuilder<List<StudyMaterial>>(
                future: model.getRecentMaterials(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Palette.darkGrey,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 48,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/undraw_not_found_-60-pq 1.png',
                              width: 200,
                            ),
                            SizedBox(height: 36),
                            Text(
                              'Nothing here yet. Go to the modules tab to add some study materials',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: snapshot.data!
                        .map(
                          (material) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: MyListTile(
                              title: material.title,
                              subtitle: formatDateTime(material.dateCreated),
                              iconData: getMaterialIcon(material.type),
                              suffixIcons: const {},
                              onPressed: () => openMaterial(material),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
