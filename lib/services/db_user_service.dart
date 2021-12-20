import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:hackathon_study_materials/models/user.dart';

class DbUserService extends GetxService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> setUserData(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<User> getUser(String userId) async {
    final userDoc = await _usersRef.doc(userId).get();
    final user = User.fromDoc(userDoc);
    // messy solution
    // user.modules = await _moduleApi.getModules(user.moduleIds);
    return user;
  }

  Future<void> deleteUser(String userId) async {
    // delete user
    await _usersRef.doc(userId).delete();
  }
}
