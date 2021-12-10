import 'package:cloud_firestore/cloud_firestore.dart';

class Material {
  String id;
  String moduleId;
  String topicId;
  String type; // one of: '#postFromTeacher', '#note' or <name of resource site>
  String title;
  String url;
  String content; // only for notes
  bool pinned;

  Material({
    required this.id,
    required this.moduleId,
    required this.topicId,
    required this.type,
    required this.title,
    required this.url,
    required this.content,
    this.pinned = false,
  });

  factory Material.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()!;
    return Material(
      id: doc.id,
      moduleId: data['moduleId'],
      topicId: data['topicId'],
      type: data['type'],
      title: data['title'],
      url: data['url'],
      content: data['content'],
      pinned: data['pinned'],
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
    };
  }

  @override
  bool operator ==(Object other) => other is Material && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
