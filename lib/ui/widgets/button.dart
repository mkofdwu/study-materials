import 'dart:async';

import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final FutureOr<dynamic> Function() onPressed;
  final bool fillWidth;
  final bool isLoading;

  const MyButton({
    Key? key,
    required this.text,
    this.isPrimary = true,
    required this.onPressed,
    this.fillWidth = false,
    this.isLoading = false,
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
      onTapCancel: () => setState(() => _pressed = false),
      child: Transform.scale(
        scale: _pressed ? 0.96 : 1,
        child: Opacity(opacity: _pressed ? 0.9 : 1, child: _mainUi()),
      ),
    );
  }

  Widget _mainUi() => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        decoration: BoxDecoration(
          color: widget.isPrimary
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: widget.fillWidth ? Alignment.center : null,
        child: widget.isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Theme.of(context).backgroundColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.text.toUpperCase(),
                style: TextStyle(
                  color: widget.isPrimary
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
      );
}
