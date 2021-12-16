import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/ui/widgets/back_button.dart';
import 'package:hackathon_study_materials/ui/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
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
      builder: (context, model, child) => _builder(context, model),
      viewModelBuilder: () => ModuleViewModel(module),
    );
  }

  Widget _builder(BuildContext context, ModuleViewModel model) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            FluentIcons.add_20_regular,
            color: Theme.of(context).backgroundColor,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: model.goToAddTopic,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyBackButton(),
                      Spacer(),
                      PressedFeedback(
                        child: Icon(FluentIcons.search_20_regular, size: 20),
                        onPressed: model.goToSearch,
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
                  SizedBox(height: 54),
                  Text(
                    'Topics',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28),
                  if (module.topics.isEmpty)
                    Text(
                      'Click the add button at the bottom to create a new topic!',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4)),
                    ),
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
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28),
                  MaterialListView(
                    future: model.getMaterials(),
                    getSubtitle: (material) => material.type,
                    onShowOptions: (material) => showMaterialOptions(
                      module.topics,
                      material,
                      model.notifyListeners,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
