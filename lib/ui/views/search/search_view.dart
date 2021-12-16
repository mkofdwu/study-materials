import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/ui/views/search/search_viewmodel.dart';
import 'package:hackathon_study_materials/ui/widgets/material_list_view.dart';
import 'package:hackathon_study_materials/ui/widgets/pressed_feedback.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  final Module? module;
  final Topic? topic;

  const SearchView({Key? key, this.module, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, model, child) => _builder(context, model),
      viewModelBuilder: () => SearchViewModel(module, topic),
    );
  }

  Widget _builder(BuildContext context, SearchViewModel model) => Scaffold(
        appBar: AppBar(
          leading: Icon(FluentIcons.search_20_regular,
              color: Theme.of(context).backgroundColor),
          title: TextField(
            controller: model.searchController,
            style: TextStyle(color: Theme.of(context).backgroundColor),
            cursorColor: Theme.of(context).backgroundColor,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                  color: Theme.of(context).backgroundColor.withOpacity(0.6)),
            ),
            onChanged: (value) => model.notifyListeners(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PressedFeedback(
                onPressed: model.dismiss,
                child: Icon(
                  FluentIcons.dismiss_20_regular,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                children: [
                  if (model.moduleFilter != null)
                    Chip(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text(
                        'Module: ' + module!.title,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      deleteIconColor: Theme.of(context).primaryColor,
                      onDeleted: model.removeModuleFilter,
                    ),
                  if (model.topicFilter != null)
                    Chip(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text(
                        'Topic: ' + topic!.title,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      deleteIconColor: Theme.of(context).primaryColor,
                      onDeleted: model.removeTopicFilter,
                    ),
                ],
              ),
            ),
            SizedBox(height: 48),
            if (model.searchController.text.isNotEmpty)
              Expanded(
                child: MaterialListView(
                  future: model.getSearchResults(model.searchController.text),
                  getSubtitle: (material) => material.type,
                  onShowOptions: model.fetchAndShowMaterialOptions,
                  showPins: false,
                  customBuilder: (numResults, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$numResults materials found'),
                        SizedBox(height: 32),
                        Expanded(child: SingleChildScrollView(child: child)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
