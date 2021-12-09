import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/ui/views/flexible_form_page/flexible_form_page.dart';
import 'package:hackathon_study_materials/ui/views/home/home_view.dart';
import 'package:hackathon_study_materials/ui/views/sign_in_or_up/sign_in_or_up_view.dart';
import 'package:hackathon_study_materials/ui/views/startup/startup_view.dart';
import 'package:hackathon_study_materials/ui/views/welcome_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SignInOrUpView),
    MaterialRoute(page: WelcomeView),
    MaterialRoute(page: FlexibleFormPage),
  ],
  dependencies: [
    // stores
    LazySingleton(classType: UserStore),
    // app services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    // firebase services
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserApiService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
