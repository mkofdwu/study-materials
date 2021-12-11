import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
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
  final snapshot =
      await FirebaseFirestore.instance.collection('materials').get();
  for (final doc in snapshot.docs) {
    await doc.reference.update({'ownerId': 'YdyU8O2dLibVcCQukpTsY3E3air2'});
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study materials',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
