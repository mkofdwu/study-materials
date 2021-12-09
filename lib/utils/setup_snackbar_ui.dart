import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/constants/palette.dart';
import 'package:stacked_services/stacked_services.dart';

void setupSnackbarUi() {
  final snackbarService = locator<SnackbarService>();
  snackbarService.registerSnackbarConfig(SnackbarConfig(
    animationDuration: const Duration(milliseconds: 600),
    backgroundColor: Palette.lightGrey,
  ));
}
