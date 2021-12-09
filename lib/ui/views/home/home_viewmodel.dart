import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/datamodels/user.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _userStore = locator<UserStore>();

  int currentTab = 0;

  User get currentUser => _userStore.currentUser;

  void onSelectTab(int index) {
    currentTab = index;
    notifyListeners();
  }
}
