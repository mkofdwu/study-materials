import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:stacked_services/stacked_services.dart';

class ChoiceBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ChoiceBottomSheet(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, top: 24, right: 30, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              Text(
                request.title!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              if (request.description != null) SizedBox(height: 12),
              if (request.description != null)
                Text(
                  request.description!,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              SizedBox(height: 24),
            ] +
            (request.data as List<String>)
                .map((choice) => GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(choice, style: TextStyle(fontSize: 16)),
                      ),
                      onTap: () => completer(
                          SheetResponse(confirmed: true, data: choice)),
                    ))
                .toList() +
            [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
                onTap: () => completer(SheetResponse(confirmed: false)),
              )
            ],
      ),
    );
  }
}
