import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/widgets/list_tile.dart';
import 'package:hackathon_study_materials/utils/show_module_options.dart';

import 'modules_controller.dart';

class ModulesView extends StatelessWidget {
  const ModulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModulesController>(
      init: ModulesController(),
      builder: (controller) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
        children: <Widget>[
              Row(
                children: [
                  Text(
                    'Modules',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  // GestureDetector(child: Icon(FluentIcons.filter_24_regular)),
                  // SizedBox(width: 24),
                  GestureDetector(
                    child: Icon(FluentIcons.search_24_regular),
                    onTap: controller.goToSearch,
                  ),
                ],
              ),
              SizedBox(height: 40),
            ] +
            controller.modules
                .map((module) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: MyListTile(
                        color: module.color,
                        title: module.title,
                        subtitle: '${module.topics.length} topics',
                        suffixIcons: {
                          FluentIcons.more_vertical_24_regular: () =>
                              showModuleOptions(controller.update, module)
                        },
                        onPressed: () => controller.goToModule(module),
                      ),
                    ))
                .toList(),
      ),
    );
  }
}
