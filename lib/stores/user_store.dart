import 'package:hackathon_study_materials/datamodels/user.dart';

class UserStore {
  User? _currentUser;

  bool get isSignedIn => _currentUser != null;
  User get currentUser => _currentUser!;
  set currentUser(User user) => _currentUser = user;
}
