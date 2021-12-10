import 'package:cloud_firestore/cloud_firestore.dart';

import 'topic.dart';

class Module {
  String id;
  String ownerId;
  String title;
  int color;
  List<Topic> topics;

  Module({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.color,
    required this.topics,
  });

  factory Module.fromDoc(DocumentSnapshot doc, List<Topic> topics) {
    final data = doc.data()!;
    return Module(
      id: doc.id,
      ownerId: data['ownerId'],
      title: data['title'],
      color: data['color'],
      topics: topics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'color': color,
    };
  }

  @override
  bool operator ==(Object other) => other is Module && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
