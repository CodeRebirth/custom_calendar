import 'package:flutter/material.dart';

class HeaderStyle {
  TextStyle? headerTitleTextStyle;
  Widget? leftChevron;
  Widget? rightChevron;
  HeaderStyle({
    this.headerTitleTextStyle,
    this.leftChevron,
    this.rightChevron,
  });

  factory HeaderStyle.normal() {
    return HeaderStyle(headerTitleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), leftChevron: const Icon(Icons.arrow_left), rightChevron: const Icon(Icons.arrow_right));
  }
}
