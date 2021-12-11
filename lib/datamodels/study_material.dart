import 'package:cloud_firestore/cloud_firestore.dart';

class StudyMaterial {
  String id;
  String moduleId;
  String? topicId;
  String type; // one of: '#postFromTeacher', '#note' or <name of resource site>
  String title;
  String url;
  String? content; // only for notes
  bool pinned;
  DateTime dateCreated;

  StudyMaterial({
    required this.id,
    required this.moduleId,
    this.topicId,
    required this.type,
    required this.title,
    required this.url,
    this.content,
    this.pinned = false,
    required this.dateCreated,
  });

  factory StudyMaterial.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()!;
    return StudyMaterial(
      id: doc.id,
      moduleId: data['moduleId'],
      topicId: data['topicId'],
      type: data['type'],
      title: data['title'],
      url: data['url'] ?? '',
      content: data['content'],
      pinned: data['pinned'],
      dateCreated: data['dateCreated'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'topicId': topicId,
      'type': type,
      'title': title,
      'url': url,
      'content': content,
      'pinned': pinned,
      'dateCreated': Timestamp.fromDate(dateCreated),
    };
  }

  @override
  bool operator ==(Object other) => other is StudyMaterial && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
