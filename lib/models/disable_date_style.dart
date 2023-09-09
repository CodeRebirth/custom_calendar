import 'package:flutter/material.dart';

class DisableDateStyle {
  final TextStyle disableDateTextStyle;
  DisableDateStyle({
    required this.disableDateTextStyle,
  });
  factory DisableDateStyle.defaultTextStyle() {
    return DisableDateStyle(
        disableDateTextStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ));
  }
}
