import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/datamodels/found_material.dart';

class MaterialApiService {
  final _materialsRef = FirebaseFirestore.instance.collection('materials');
  final _modulesRef = FirebaseFirestore.instance.collection('modules');

  Future<List<StudyMaterial>> getMaterials(
    String moduleId, {
    String? topicId,
    String? filterByType,
    String? sortBy,
    bool descending = false,
  }) async {
    Query query;

    if (topicId != null) {
      query = _materialsRef.where('topicId', isEqualTo: topicId);
    } else {
      query = _materialsRef.where('moduleId', isEqualTo: moduleId);
    }

    if (filterByType != null) {
      query = query.where('type', isEqualTo: filterByType);
    }

    query = query.orderBy('pinned', descending: true);

    if (sortBy != null) {
      query = query.orderBy(sortBy, descending: descending);
    }

    final snapshot = await query.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs.map((doc) => StudyMaterial.fromDoc(doc)).toList();
  }

  Future<List<StudyMaterial>> getRecentMaterials(
      String ownerId, int limit) async {
    final snapshot = await _materialsRef
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('dateCreated', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => StudyMaterial.fromDoc(doc)).toList();
  }

  Future<List<StudyMaterial>> searchForMaterials(
    String ownerId,
    String searchQuery, {
    String? moduleId,
    String? topicId,
  }) async {
    // may need to be modified for collaborative modules
    Query query;
    if (topicId != null) {
      query = _materialsRef.where('topicId', isEqualTo: topicId);
    } else if (moduleId != null) {
      query = _materialsRef.where('moduleId', isEqualTo: moduleId);
    } else {
      query = _materialsRef.where('ownerId', isEqualTo: ownerId);
    }
    // TODO: this could be optimized
    final snapshot = (await query.get()) as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .where((doc) => (doc.data()['title'] as String)
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .map((doc) => StudyMaterial.fromDoc(doc))
        .toList();
  }

  Future<StudyMaterial> addFoundMaterial(
    String ownerId,
    String moduleId,
    String topicId,
    FoundMaterial found,
  ) async {
    final ref = await _materialsRef.add({
      'ownerId': ownerId,
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
    String ownerId,
    String moduleId,
    String topicId,
    String title,
    String url,
  ) async {
    final ref = await _materialsRef.add({
      'ownerId': ownerId,
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
    String ownerId,
    String moduleId,
    String topicId,
    String title,
    String content,
  ) async {
    final ref = await _materialsRef.add({
      'ownerId': ownerId,
      'moduleId': moduleId,
      'topicId': topicId,
      'title': title,
      'url': '',
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
}
