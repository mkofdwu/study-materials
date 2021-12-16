import 'package:hackathon_study_materials/services/api/google_search_service.dart';
import 'package:hackathon_study_materials/services/api/material_api_service.dart';
import 'package:hackathon_study_materials/services/api/microsoft_teams_service.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:hackathon_study_materials/stores/user_store.dart';
import 'package:hackathon_study_materials/services/api/user_api_service.dart';
import 'package:hackathon_study_materials/services/auth_service.dart';
import 'package:hackathon_study_materials/ui/views/about_view.dart';
import 'package:hackathon_study_materials/ui/views/flexible_form_page/flexible_form_page.dart';
import 'package:hackathon_study_materials/ui/views/home/home_view.dart';
import 'package:hackathon_study_materials/ui/views/module/module_view.dart';
import 'package:hackathon_study_materials/ui/views/note/note_view.dart';
import 'package:hackathon_study_materials/ui/views/search/search_view.dart';
import 'package:hackathon_study_materials/ui/views/sign_in_or_up/sign_in_or_up_view.dart';
import 'package:hackathon_study_materials/ui/views/startup/startup_view.dart';
import 'package:hackathon_study_materials/ui/views/topic/topic_view.dart';
import 'package:hackathon_study_materials/ui/views/welcome_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SignInOrUpView),
    MaterialRoute(page: WelcomeView),
    MaterialRoute(page: FlexibleFormPage),
    MaterialRoute(page: ModuleView),
    MaterialRoute(page: TopicView),
    MaterialRoute(page: NoteView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: AboutView),
  ],
  dependencies: [
    // stores
    LazySingleton(classType: UserStore),
    // app services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(
      classType: ThemeService,
      resolveUsing: ThemeService.getInstance,
    ),
    // firebase services
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserApiService),
    LazySingleton(classType: ModuleApiService),
    LazySingleton(classType: MaterialApiService),
    // other 3rd party services
    LazySingleton(classType: GoogleSearchService),
    LazySingleton(classType: MicrosoftTeamsService),
  ],
  // logger: StackedLogger(),
)
class AppSetup {}
