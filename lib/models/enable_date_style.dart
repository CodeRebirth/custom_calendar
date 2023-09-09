import 'package:flutter/material.dart';

class EnableDateStyle {
  final TextStyle enableDateTextStyle;
  EnableDateStyle({
    required this.enableDateTextStyle,
  });
  factory EnableDateStyle.defaultTextStyle() {
    return EnableDateStyle(enableDateTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
  }
}
