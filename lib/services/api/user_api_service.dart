import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hackathon_study_materials/datamodels/user.dart';

class UserApiService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> setUserData(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<User> getUser(String userId) async {
    final userDoc = await _usersRef.doc(userId).get();
    return User.fromDoc(userDoc);
  }

  Future<void> deleteUser(String userId) async {
    // delete user
    await _usersRef.doc(userId).delete();
  }
}
