import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackathon_study_materials/constants/palette.dart';

class MyButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final FutureOr<dynamic> Function() onPressed;

  const MyButton({
    Key? key,
    required this.text,
    this.isPrimary = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Future.delayed(const Duration(milliseconds: 200), widget.onPressed);
      },
      child: Transform.scale(
        scale: _pressed ? 0.96 : 1,
        child: Opacity(opacity: _pressed ? 0.9 : 1, child: _mainUi()),
      ),
    );
  }

  Widget _mainUi() => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        decoration: BoxDecoration(
          color: widget.isPrimary ? Palette.darkGrey : Palette.lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.text.toUpperCase(),
          style: TextStyle(
            color: widget.isPrimary ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      );
}
