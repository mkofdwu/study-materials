import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:stacked/stacked.dart';

class ReviewFoundViewModel extends BaseViewModel {
  final Function(dynamic) onValueChanged;

  ReviewFoundViewModel(
      Map<String, List<FoundMaterial>> topicToFound, this.onValueChanged) {
    onValueChanged(topicToFound);
  }

  void toggleSelected(FoundMaterial foundMaterial) {
    foundMaterial.selected = !foundMaterial.selected;
    notifyListeners();
  }
}
