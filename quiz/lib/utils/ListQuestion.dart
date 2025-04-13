import 'package:flutter/material.dart';

class ListQuestion extends StatelessWidget {
  const ListQuestion({super.key, required this.question, required this.options});
  final String question;
  final List<dynamic> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20,),

        ...options.map((option) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Text(
            option,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        )),
      ],
    );
  }
}
