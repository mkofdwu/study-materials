import 'package:flutter/material.dart';

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
    return Row(
      children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: iconData == null
                    ? null
                    : Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.1)),
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
                    : Icon(iconData, color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: GestureDetector(
                onTap: onPressed,
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
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] +
          suffixIcons
              .map((iconData, onTapIcon) => MapEntry(
                    iconData,
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: onTapIcon,
                        child: Icon(iconData, size: 20),
                      ),
                    ),
                  ))
              .values
              .toList(),
    );
  }
}
