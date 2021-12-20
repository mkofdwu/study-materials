import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/module.dart';
import 'package:hackathon_study_materials/models/topic.dart';
import 'package:hackathon_study_materials/utils/random_color.dart';

class DbModuleService extends GetxService {
  final _modulesRef = FirebaseFirestore.instance.collection('modules');

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
    return Module.fromDoc(await moduleDoc.get(), []);
  }

  Future<void> editModule(Module module) async {
    await _modulesRef.doc(module.id).set(module.toMap());
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

  Future<Topic> addTopic(String moduleId, String title) async {
    final ref = await _modulesRef
        .doc(moduleId)
        .collection('topics')
        .add({'moduleId': moduleId, 'title': title, 'materials': []});
    return Topic.fromDoc(await ref.get());
  }

  Future<void> editTopic(Topic topic) async {
    await _modulesRef
        .doc(topic.moduleId)
        .collection('topics')
        .doc(topic.id)
        .set(topic.toMap());
  }

  Future<void> deleteTopic(Topic topic) async {
    // materials are still preserved
    await _modulesRef
        .doc(topic.moduleId)
        .collection('topics')
        .doc(topic.id)
        .delete();
  }
}
