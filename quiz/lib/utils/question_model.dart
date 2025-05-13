import 'package:flutter/material.dart';

class QuestionModel {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers = List.generate(4, (_) => TextEditingController());
  int correctOptionIndex = -1; // -1 means none selected
}
