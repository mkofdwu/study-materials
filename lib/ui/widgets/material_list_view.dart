import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/ui/widgets/list_tile.dart';
import 'package:hackathon_study_materials/utils/get_material_icon.dart';
import 'package:hackathon_study_materials/utils/open_material.dart';

class MaterialListView extends StatelessWidget {
  final Future<List<StudyMaterial>> future;
  final String Function(StudyMaterial) getSubtitle;
  final Function(StudyMaterial)? onShowOptions;
  final bool showPins;
  final Widget Function(int, Widget)? customBuilder;

  const MaterialListView({
    Key? key,
    required this.future,
    required this.getSubtitle,
    this.onShowOptions,
    this.showPins = true,
    this.customBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudyMaterial>>(
      future: future,
      builder: (context, snapshot) {
        // very similar to in topic view
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
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
                    'No materials here yet...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final widget = Column(
          children: snapshot.data!
              .map(
                (material) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MyListTile(
                    title: material.title,
                    subtitle: getSubtitle(material),
                    iconData: getMaterialIcon(material.type),
                    suffixIcons: {
                      if (showPins && material.pinned)
                        FluentIcons.pin_20_filled: () {},
                      if (onShowOptions != null)
                        FluentIcons.more_vertical_20_regular: () =>
                            onShowOptions!(material),
                    },
                    onPressed: () => openMaterial(material),
                  ),
                ),
              )
              .toList(),
        );
        return customBuilder == null
            ? widget
            : customBuilder!(snapshot.data!.length, widget); // no. of materials
      },
    );
  }
}
