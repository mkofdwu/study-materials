import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/ui/widgets/button.dart';
import 'package:hackathon_study_materials/ui/widgets/text_field.dart';
import 'package:stacked_services/stacked_services.dart';

class InputBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const InputBottomSheet(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  State<InputBottomSheet> createState() => _InputBottomSheetState();
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  final _textController = TextEditingController();
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.request.data; // default value
  }

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
            widget.request.title!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (widget.request.description != null) SizedBox(height: 12),
          if (widget.request.description != null)
            Text(
              widget.request.description!,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          SizedBox(height: 30),
          MyTextField(controller: _textController, error: _inputError),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: widget.request.mainButtonTitle ?? 'Confirm',
                  fillWidth: true,
                  onPressed: () {
                    if (_textController.text.isEmpty) {
                      setState(() {
                        _inputError = "You can't leave this blank";
                      });
                    } else {
                      widget.completer(SheetResponse(
                        confirmed: true,
                        data: _textController.text,
                      ));
                    }
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: MyButton(
                  text: widget.request.secondaryButtonTitle ?? 'Cancel',
                  isPrimary: false,
                  fillWidth: true,
                  onPressed: () =>
                      widget.completer(SheetResponse(confirmed: false)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
