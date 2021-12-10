import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:stacked_services/stacked_services.dart';

class YesNoBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const YesNoBottomSheet(
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
        children: [
          Text(
            request.title!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text(
            request.description!,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: request.mainButtonTitle ?? 'Ok',
                  fillWidth: true,
                  onPressed: () => completer(SheetResponse(confirmed: true)),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: MyButton(
                  text: request.secondaryButtonTitle ?? 'Cancel',
                  isPrimary: false,
                  fillWidth: true,
                  onPressed: () => completer(SheetResponse(confirmed: false)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
