import 'package:flutter/cupertino.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

IconData getMaterialIcon(String type) {
  switch (type) {
    case 'Books':
      return FluentIcons.book_20_regular;
    case 'Academic papers':
      return FluentIcons.hat_graduation_20_regular;
    case 'Youtube videos':
      return FluentIcons.play_20_regular;
    case 'Open source projects':
      return FluentIcons.people_community_20_regular;
    case 'Note':
      return FluentIcons.note_20_regular;
    default:
      return FluentIcons.link_20_regular;
  }
}
