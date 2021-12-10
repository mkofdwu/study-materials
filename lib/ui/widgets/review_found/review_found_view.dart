import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'review_found_viewmodel.dart';

class ReviewFoundView extends StatelessWidget {
  const ReviewFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReviewFoundViewModel>.reactive(
      builder: (context, model, child) => ListView(),
      viewModelBuilder: () => ReviewFoundViewModel(),
    );
  }
}
