import 'package:flutter/material.dart';
import 'package:quiz/utils/colors.dart';

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final int index;
  final int totalQuestions;
  final String selectedOption;
  final Function(String) onOptionSelected;

  const QuestionWidget({
    Key? key,
    required this.questionData,
    required this.index,
    required this.totalQuestions,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> options = (questionData['Options'] as List)
        .map((opt) => opt['option'] as String)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${index + 1}/$totalQuestions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          questionData['question'],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 50),
        ...options.map((option) {
          final bool isSelected = selectedOption == option;
          return InkWell(
          onTap: (){
            onOptionSelected(option);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 27),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
              color: isSelected? AppColors.primary : Colors.transparent,
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isSelected? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
        }),
      ],
    );
  }
}

class QuestionCheckWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final int index;
  final int totalQuestions;
  final String selectedOption;

  const QuestionCheckWidget({
    Key? key,
    required this.questionData,
    required this.index,
    required this.totalQuestions,
    required this.selectedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> options = (questionData['Options'] as List)
        .map((opt) => opt['option'] as String)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${index + 1}/$totalQuestions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          questionData['question'],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 50),
        ...options.map((option) {
          final bool isSelected = selectedOption == option;
          final bool isCorrect = questionData['answer'] == option;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 27),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
              color: isSelected
              ?isCorrect
              ?AppColors.success :AppColors.error
              :Colors.transparent
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }),
        SizedBox(height: 30,),
        Text(
          'Answer: ${questionData['answer']}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        )
      ],
    );
  }
}
