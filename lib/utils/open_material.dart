import 'package:hackathon_study_materials/app/app.locator.dart';
import 'package:hackathon_study_materials/app/app.router.dart';
import 'package:hackathon_study_materials/datamodels/study_material.dart';
import 'package:hackathon_study_materials/services/api/module_api_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

void openMaterial(StudyMaterial material) {
  if (material.type == 'Note') {
    locator<NavigationService>().navigateTo(
      Routes.noteView,
      arguments: NoteViewArguments(
        title: '',
        content: '',
        saveNote: (title, content) async {
          material.title = title;
          material.content = content;
          await locator<ModuleApiService>().editMaterial(material);
        },
      ),
    );
  } else {
    if (material.url.startsWith(RegExp(r'https?://'))) {
      launch(material.url);
    } else {
      launch('https://' + material.url);
    }
  }
}
