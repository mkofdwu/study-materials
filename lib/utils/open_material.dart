import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/study_material.dart';
import 'package:hackathon_study_materials/services/db_material_service.dart';
import 'package:hackathon_study_materials/views/note/note_view.dart';
import 'package:url_launcher/url_launcher.dart';

void openMaterial(StudyMaterial material) {
  if (material.type == 'Note') {
    Get.to(NoteView(
      title: material.title,
      content: material.content!,
      saveNote: (title, content) async {
        material.title = title;
        material.content = content;
        await Get.find<DbMaterialService>().editMaterial(material);
      },
    ));
  } else {
    if (material.url.startsWith(RegExp(r'https?://'))) {
      launch(material.url);
    } else {
      launch('https://' + material.url);
    }
  }
}
