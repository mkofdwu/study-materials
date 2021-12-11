import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';
import 'package:hackathon_study_materials/utils/open_material.dart';
import 'package:hackathon_study_materials/utils/show_material_options.dart';
import 'package:hackathon_study_materials/utils/show_module_options.dart';
import 'package:stacked/stacked.dart';

import 'module_viewmodel.dart';

class ModuleView extends StatelessWidget {
  final Module module;

  const ModuleView({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ModuleViewModel>.reactive(
      builder: (context, model, child) => _builder(model),
      viewModelBuilder: () => ModuleViewModel(module),
    );
  }

  Widget _builder(ModuleViewModel model) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(FluentIcons.add_20_regular),
          backgroundColor: Palette.darkGrey,
          onPressed: model.goToAddTopic,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBackButton(),
                  SizedBox(height: 40),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(module.color),
                    ),
                    child: Center(
                      child: Text(
                        module.title[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    module.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '${module.topics.length} topics',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      PressedFeedback(
                        child: Icon(FluentIcons.search_20_regular, size: 20),
                        onPressed: () => model.goToSearch,
                      ),
                      SizedBox(width: 16),
                      PressedFeedback(
                        child: Icon(FluentIcons.filter_20_regular, size: 20),
                        onPressed: () => model.goToFilter,
                      ),
                      SizedBox(width: 16),
                      PressedFeedback(
                        child: Icon(FluentIcons.more_vertical_20_regular,
                            size: 20),
                        onPressed: () => showModuleOptions(
                          module,
                          model.notifyListeners,
                          backOnDelete: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Topics',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: module.topics
                        .asMap()
                        .map((i, topic) => MapEntry(
                            i,
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: PressedFeedback(
                                onPressed: () => model.goToTopic(topic),
                                child: Text(
                                  '${i + 1}. ' + topic.title,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )))
                        .values
                        .toList(),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'All materials',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28),
                  FutureBuilder<List<StudyMaterial>>(
                    future: model.getMaterials(),
                    builder: (context, snapshot) {
                      // very similar to in topic view
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
                      return Column(
                        children: snapshot.data!
                            .map(
                              (material) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MyListTile(
                                  title: material.title,
                                  subtitle: material.type,
                                  iconData: getMaterialIcon(material.type),
                                  suffixIcons: {
                                    if (material.pinned)
                                      FluentIcons.pin_20_filled: () {},
                                    // FluentIcons.more_vertical_20_regular: () =>
                                    //     showMaterialOptions(
                                    //       module.topics,
                                    //       topic,
                                    //       material,
                                    //       model.notifyListeners,
                                    //     ),
                                  },
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
          ),
        ),
      );
}
