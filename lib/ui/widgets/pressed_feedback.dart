import 'dart:async';

import 'package:flutter/material.dart';

class PressedFeedback extends StatefulWidget {
  final Widget child;
  final FutureOr<dynamic> Function() onPressed;

  const PressedFeedback({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  _PressedFeedbackState createState() => _PressedFeedbackState();
}

class _PressedFeedbackState extends State<PressedFeedback> {
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
        child: Opacity(opacity: _pressed ? 0.9 : 1, child: widget.child),
      ),
    );
  }
}
