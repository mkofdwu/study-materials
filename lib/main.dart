import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/constants/themes.dart';
import 'package:hackathon_study_materials/utils/setup_bottom_sheet_ui.dart';
import 'package:hackathon_study_materials/utils/setup_snackbar_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:stacked_themes/stacked_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeManager.initialise();
  setupLocator();
  setupBottomSheetUi();
  setupSnackbarUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.light,
      lightTheme: kLightTheme,
      darkTheme: kDarkTheme,
      builder: (context, regularTheme, darkTheme, themeMode) {
        return MaterialApp(
          title: 'Study materials',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: regularTheme,
          darkTheme: darkTheme,
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,
        );
      },
    );
  }
}
