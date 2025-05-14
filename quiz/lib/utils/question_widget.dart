import 'package:flutter/material.dart';
import 'package:quiz/utils/colors.dart';
import 'package:quiz/utils/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            fontSize: Responsive.scale*8,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox(height: Responsive.heightUnit*3),
        Container(
          height: MediaQuery.of(context).size.height*0.135,
          width: double.infinity,
          child: AutoSizeText(
            questionData['question'],
            style: TextStyle(
              fontSize: Responsive.scale*12,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontFamily: 'OpenSans'
            ),
          ),
        ),
        SizedBox(height: Responsive.heightUnit*5),
        ...options.map((option) {
          final bool isSelected = selectedOption == option;
          return InkWell(
          onTap: (){
            onOptionSelected(option);
          },
          child: Container(
            height: MediaQuery.of(context).size.height*0.11,
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            padding:
            EdgeInsets.symmetric(horizontal: Responsive.widthUnit*10, vertical: Responsive.heightUnit*3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
              color: isSelected? AppColors.primary : Colors.transparent,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                option,
                style: TextStyle(
                  fontSize: Responsive.scale*8,
                  fontWeight: FontWeight.w700,
                  color: isSelected? Colors.white : AppColors.textPrimary,
                  fontFamily: 'OpenSans'
                ),
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
            fontSize: Responsive.scale*8,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox(height: Responsive.heightUnit*3),
        Container(
          height: MediaQuery.of(context).size.height*0.135,
          width: double.infinity,
          child: AutoSizeText(
            questionData['question'],
            style: TextStyle(
                fontSize: Responsive.scale*12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontFamily: 'OpenSans'
            ),
          ),
        ),
        SizedBox(height: Responsive.heightUnit*5),
        ...options.map((option) {
          final bool isSelected = selectedOption == option;
          final bool isCorrect = questionData['answer'] == option;
          return Container(
            height: MediaQuery.of(context).size.height*0.11,
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            padding:
            EdgeInsets.symmetric(horizontal: Responsive.widthUnit*10, vertical: Responsive.heightUnit*3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
              color: isSelected
              ?isCorrect
              ?AppColors.success :AppColors.error
              :Colors.transparent
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                option,
                style: TextStyle(
                  fontSize: Responsive.scale*8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'OpenSans'
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 20,),
        Container(
          height: Responsive.heightUnit*15,
          child: AutoSizeText(
            'Answer: ${questionData['answer']}',
            style: TextStyle(
              fontSize: Responsive.scale*7.5,
              fontWeight: FontWeight.w600,
              color: Colors.green,
              fontFamily: 'OpenSans'
            ),
          ),
        )
      ],
    );
  }
}
