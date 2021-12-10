import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';

import 'package:hackathon_study_materials/datamodels/user.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';

class UserApiService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  final _moduleApi = locator<ModuleApiService>();

  Future<void> setUserData(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<User> getUser(String userId) async {
    final userDoc = await _usersRef.doc(userId).get();
    final user = User.fromDoc(userDoc);
    // messy solution
    user.modules = await _moduleApi.getModules(user.moduleIds);
    return user;
  }

  Future<void> deleteUser(String userId) async {
    // delete user
    await _usersRef.doc(userId).delete();
  }
}
