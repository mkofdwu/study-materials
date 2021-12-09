import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String moduleId;
  String title;
  List<String> materialIds; // list of ids

  Topic({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.materialIds,
  });

  factory Topic.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()!;
    return Topic(
      id: doc.id,
      moduleId: data['moduleId'],
      title: data['title'],
      materialIds: List<String>.from(data['materials']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'title': title,
      'materials': materialIds,
    };
  }

  @override
  bool operator ==(Object other) => other is Topic && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
