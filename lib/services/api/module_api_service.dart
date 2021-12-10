import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/material.dart';
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

  Future<Material> addFoundMaterial(
      String moduleId, String topicId, FoundMaterial found) async {
    final ref = await _materialsRef.add({
      'moduleId': moduleId,
      'topicId': topicId,
      'title': found.title,
      'url': found.url,
      'type': found.siteName,
      'pinned': false,
    });
    final material = Material.fromDoc(await ref.get());
    // add to topic list as well
    await _modulesRef.doc(moduleId).collection('topics').doc(topicId).update({
      'materials': FieldValue.arrayUnion([material.id])
    });
    return material;
  }
}
