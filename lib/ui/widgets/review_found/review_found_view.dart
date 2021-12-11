import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/fluent_icons.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';
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
      builder: (context, model, child) => SingleChildScrollView(
        child: topicToFound.length == 1
            ? _buildFoundMaterialsList(model, topicToFound.values.first, null)
            // dont show topic title if is only one
            : Column(
                children: topicToFound
                    .map(
                      (topicName, foundMaterials) => MapEntry(
                        topicName,
                        _buildFoundMaterialsList(
                          model,
                          foundMaterials,
                          topicName,
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
      ),
      viewModelBuilder: () =>
          ReviewFoundViewModel(topicToFound, onValueChanged),
    );
  }

  Widget _buildFoundMaterialsList(
    ReviewFoundViewModel model,
    List<FoundMaterial> foundMaterials,
    String? topicName,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (topicName != null
                ? <Widget>[
                    Text(
                      topicName,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),
                  ]
                : <Widget>[]) +
            foundMaterials
                .map((found) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () => model.toggleSelected(found),
                        child: MyListTile(
                          title: found.title,
                          subtitle: found.siteName,
                          iconData: getMaterialIcon(found.siteName),
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
                .toList() +
            [SizedBox(height: 32)],
      );
}
