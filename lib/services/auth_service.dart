import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:hackathon_study_materials/constants/default_resource_sites.dart';
import 'package:hackathon_study_materials/datamodels/user.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';

class AuthService {
  final _userStore = locator<UserStore>();
  final _userApi = locator<UserApiService>();

  final _fbAuth = fb.FirebaseAuth.instance;

  Future<void> refreshCurrentUser() async {
    if (_fbAuth.currentUser != null) {
      _userStore.currentUser = await _userApi.getUser(_fbAuth.currentUser!.uid);
    }
  }

  Future<Map<String, String>> signIn(
      {required String email, required String password}) async {
    // returns errors
    final errors = {
      if (email.isEmpty) 'email': 'Please enter a email',
      if (password.isEmpty) 'password': 'Please enter a password'
    };
    if (errors.isNotEmpty) return errors;
    try {
      await _fbAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await refreshCurrentUser();
      return {};
    } on fb.FirebaseAuthException {
      return {'password': 'Invalid email or password'};
    }
  }

  Future<Map<String, String>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final errors = {
      if (email.isEmpty) 'email': 'Please enter a email',
      if (password.isEmpty) 'password': 'Please enter a password',
      if (confirmPassword != password)
        'confirmPassword': 'The passwords entered do not match',
    };
    if (errors.isNotEmpty) return errors;
    try {
      final credential = await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _userApi.setUserData(User(
        id: credential.user!.uid,
        email: email,
        moduleIds: [],
        resourceSites: defaultResourceSites,
        numResults: 3,
      ));
      await refreshCurrentUser();
      return {};
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return {'email': 'This email is already taken'};
      }
      if (e.code == 'invalid-email') {
        return {
          'email': 'Your email cannot contain any spaces or special characters'
        };
      }
      return {'email': e.message ?? ''};
    }
  }

  Future<void> signOut() => _fbAuth.signOut();

  Future<void> deleteAccount() async {
    await _userApi.deleteUser(_userStore.currentUser.id);
    await _fbAuth.currentUser!.delete();
  }

  Future<void> updateEmail(String newEmail) async {
    await _fbAuth.currentUser!.updateEmail(newEmail);
    _userStore.currentUser.email = newEmail;
  }
}
