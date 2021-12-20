import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? iconData;
  final int? color; // if no icon is supplied color is used instead
  final Map<IconData, Function()> suffixIcons;
  final Function() onPressed;

  const MyListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.iconData,
    this.color,
    required this.suffixIcons,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        // makes entire tile clickable
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: iconData == null
                        ? null
                        : Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1)),
                    color: iconData == null ? Color(color!) : null,
                  ),
                  child: Center(
                    child: iconData == null
                        ? Text(
                            title[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Icon(iconData, color: Get.theme.primaryColor),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ] +
              suffixIcons
                  .map((iconData, onTapIcon) => MapEntry(
                        iconData,
                        GestureDetector(
                          onTap: onTapIcon,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            child: Icon(iconData, size: 20),
                          ),
                        ),
                      ))
                  .values
                  .toList(),
        ),
      ),
    );
  }
}
