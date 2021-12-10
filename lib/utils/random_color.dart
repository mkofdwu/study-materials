import 'dart:math';

import 'package:flutter/painting.dart';

Color randomColor() =>
    Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
