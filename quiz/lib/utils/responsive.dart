import 'package:flutter/material.dart';

class Responsive {
  static late double heightUnit;
  static late double widthUnit;
  static late double scale;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    heightUnit = size.height / 200;
    widthUnit = size.width / 100;
    scale = (size.width + size.height) / 2 / 300;
  }
}