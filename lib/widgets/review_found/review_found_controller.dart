import 'package:get/get.dart';
import 'package:hackathon_study_materials/models/found_material.dart';

class ReviewFoundController extends GetxController {
  final Function(dynamic) onValueChanged;

  ReviewFoundController(
      Map<String, List<FoundMaterial>> topicToFound, this.onValueChanged) {
    onValueChanged(topicToFound);
  }

  void toggleSelected(FoundMaterial foundMaterial) {
    foundMaterial.selected = !foundMaterial.selected;
    update();
  }
}
