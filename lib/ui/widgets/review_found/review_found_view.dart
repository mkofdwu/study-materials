import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:stacked/stacked.dart';

import 'review_found_viewmodel.dart';

class ReviewFoundView extends StatelessWidget {
  final Map<String, List<FoundMaterial>> topicToFound;
  final Function(dynamic) onValueChanged;

  const ReviewFoundView({
    Key? key,
    required this.topicToFound,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReviewFoundViewModel>.reactive(
      builder: (context, model, child) =>
          _buildFoundMaterialsList(model, topicToFound.values.first),
      viewModelBuilder: () =>
          ReviewFoundViewModel(topicToFound, onValueChanged),
    );
  }

  Widget _buildFoundMaterialsList(
    ReviewFoundViewModel model,
    List<FoundMaterial> foundMaterials,
  ) =>
      SingleChildScrollView(
        child: Column(
          children: foundMaterials
              .map((found) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => model.toggleSelected(found),
                      child: MyListTile(
                        title: found.title,
                        subtitle: found.siteName,
                        iconData: FluentIcons.link_20_regular,
                        suffixIcons: found.selected
                            ? {
                                FluentIcons.checkmark_20_regular: () =>
                                    model.toggleSelected(found)
                              }
                            : {},
                        onPressed: () => model.toggleSelected(found),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
}
