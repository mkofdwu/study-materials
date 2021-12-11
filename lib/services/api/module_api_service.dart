import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/utils/random_color.dart';

class ModuleApiService {
  final _usersRef = FirebaseFirestore.instance.collection('users');
  final _modulesRef = FirebaseFirestore.instance.collection('modules');
  final _materialsRef = FirebaseFirestore.instance.collection('materials');

  Future<List<Module>> getModules(List<String> moduleIds) async {
    final modules = <Module>[];
    for (final moduleId in moduleIds) {
      final moduleDoc = await _modulesRef.doc(moduleId).get();
      final topicDocs = await moduleDoc.reference.collection('topics').get();
      final topics =
          topicDocs.docs.map((topicDoc) => Topic.fromDoc(topicDoc)).toList();
      modules.add(Module.fromDoc(moduleDoc, topics));
    }
    return modules;
  }

  Future<Module> addModule(String ownerId, String moduleName) async {
    final moduleDoc = await _modulesRef.add({
      'ownerId': ownerId, // should access current user directly
      'title': moduleName,
      'color': randomColor().value,
    });
    await _usersRef.doc(ownerId).update({
      'modules': FieldValue.arrayUnion([moduleDoc.id])
    });
    return Module.fromDoc(await moduleDoc.get(), []);
  }

  Future<Topic> addTopic(String moduleId, String title) async {
    final ref = await _modulesRef
        .doc(moduleId)
        .collection('topics')
        .add({'moduleId': moduleId, 'title': title, 'materials': []});
    return Topic.fromDoc(await ref.get());
  }

  Future<StudyMaterial> addFoundMaterial(
      String moduleId, String topicId, FoundMaterial found) async {
    final ref = await _materialsRef.add({
      'moduleId': moduleId,
      'topicId': topicId,
      'title': found.title,
      'url': found.url,
      'type': found.siteName,
      'pinned': false,
      'dateCreated': Timestamp.now(),
    });
    final material = StudyMaterial.fromDoc(await ref.get());
    // add to topic list as well
    await _modulesRef.doc(moduleId).collection('topics').doc(topicId).update({
      'materials': FieldValue.arrayUnion([material.id])
    });
    return material;
  }

  Future<StudyMaterial> addLink(
    String moduleId,
    String topicId,
    String title,
    String url,
  ) async {
    final ref = await _materialsRef.add({
      'moduleId': moduleId,
      'topicId': topicId,
      'title': title,
      'url': url,
      'type': 'Website',
      'pinned': false,
      'dateCreated': Timestamp.now(),
    });
    await _modulesRef.doc(moduleId).collection('topics').doc(topicId).update({
      'materials': FieldValue.arrayUnion([ref.id])
    });
    return StudyMaterial.fromDoc(await ref.get());
  }

  Future<StudyMaterial> addNote(
    String moduleId,
    String topicId,
    String title,
    String content,
  ) async {
    final ref = await _materialsRef.add({
      'moduleId': moduleId,
      'topicId': topicId,
      'title': title,
      'content': content,
      'type': 'Note',
      'pinned': false,
      'dateCreated': Timestamp.now(),
    });
    await _modulesRef.doc(moduleId).collection('topics').doc(topicId).update({
      'materials': FieldValue.arrayUnion([ref.id])
    });
    return StudyMaterial.fromDoc(await ref.get());
  }

  Future<List<StudyMaterial>> getModuleMaterials(String moduleId) async {
    final snapshot = await _materialsRef
        .where('moduleId', isEqualTo: moduleId)
        .orderBy('pinned', descending: true)
        .get();
    return snapshot.docs.map((doc) => StudyMaterial.fromDoc(doc)).toList();
  }

  Future<List<StudyMaterial>> getTopicMaterials(String topicId) async {
    final snapshot = await _materialsRef
        .where('topicId', isEqualTo: topicId)
        .orderBy('pinned', descending: true)
        .get();
    return snapshot.docs.map((doc) => StudyMaterial.fromDoc(doc)).toList();
  }

  Future<List<StudyMaterial>> getRecentMaterials(int limit) async {
    final snapshot = await _materialsRef
        .orderBy('dateCreated', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => StudyMaterial.fromDoc(doc)).toList();
  }

  Future<void> editMaterial(StudyMaterial material) async {
    await _materialsRef.doc(material.id).set(material.toMap());
  }

  Future<void> deleteMaterial(StudyMaterial material) async {
    await _modulesRef
        .doc(material.moduleId)
        .collection('topics')
        .doc(material.topicId)
        .update({
      'materials': FieldValue.arrayRemove([material.id])
    });
    await _materialsRef.doc(material.id).delete();
  }

  // materials are still preserved

  Future<void> deleteTopic(Topic topic) async {
    await _modulesRef
        .doc(topic.moduleId)
        .collection('topics')
        .doc(topic.id)
        .delete();
  }

  Future<void> deleteModule(Module module) async {
    // have to delete each topic doc individually
    final snapshot =
        await _modulesRef.doc(module.id).collection('topics').get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
    // then delete module doc
    await _modulesRef.doc(module.id).delete();
  }

  Future<void> editModule(Module module) async {
    await _modulesRef.doc(module.id).set(module.toMap());
  }

  Future<void> editTopic(Topic topic) async {
    await _modulesRef
        .doc(topic.moduleId)
        .collection('topics')
        .doc(topic.id)
        .set(topic.toMap());
  }
}
