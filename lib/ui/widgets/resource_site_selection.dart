import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';

class ResourceSiteSelection extends StatefulWidget {
  final List<ResourceSite> resourceSites;
  final Function onValueChanged;

  const ResourceSiteSelection(
      {Key? key, required this.resourceSites, required this.onValueChanged})
      : super(key: key);

  @override
  State<ResourceSiteSelection> createState() => _ResourceSiteSelectionState();
}

class _ResourceSiteSelectionState extends State<ResourceSiteSelection> {
  List<ResourceSite> _selection = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Text(
              'Search for supplementary material',
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    activeColor: Palette.darkGrey,
                    value: _selection.length == widget.resourceSites.length,
                    onChanged: (selected) {
                      if (selected ?? false) {
                        setState(
                            () => _selection = List.from(widget.resourceSites));
                      } else {
                        setState(() => _selection = <ResourceSite>[]);
                      }
                      widget.onValueChanged(_selection);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Text('All'),
              ]),
            ),
          ] +
          widget.resourceSites
              .map(
                (resourceSite) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        activeColor: Palette.darkGrey,
                        value: _selection.contains(resourceSite),
                        onChanged: (selected) {
                          if (selected ?? false) {
                            setState(() => _selection.add(resourceSite));
                          } else {
                            setState(() => _selection.remove(resourceSite));
                          }
                          widget.onValueChanged(_selection);
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(resourceSite.title),
                  ]),
                ),
              )
              .toList(),
    );
  }
}
