import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/enums/bottom_sheet_type.dart';
import 'package:hackathon_study_materials/ui/widgets/yesno_bottom_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.yesno: (context, sheetRequest, completer) =>
        YesNoBottomSheet(request: sheetRequest, completer: completer)
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
