import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/datamodels/module.dart';
import 'package:hackathon_study_materials/datamodels/topic.dart';
import 'package:hackathon_study_materials/utils/random_color.dart';

class ModuleApiService {
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
}
