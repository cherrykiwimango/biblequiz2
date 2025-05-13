import 'package:flutter/material.dart';
import 'package:quiz/utils/question_model.dart';
import 'package:quiz/utils/responsive.dart';
import 'colors.dart';

class QuestionInput extends StatefulWidget {
  final int index;
  final QuestionModel model;
  const QuestionInput({
    Key? key,
    required this.index,
    required this.model,
  }) : super(key: key);

  @override
  State<QuestionInput> createState() => _QuestionInputState();
}

class _QuestionInputState extends State<QuestionInput> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Question ${widget.index+1}",
            style: TextStyle(
              fontSize: Responsive.scale * 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(height: Responsive.heightUnit * 3),
          Text(
            "Enter the Question",
            style: TextStyle(
              fontSize: Responsive.scale * 7,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(height: Responsive.heightUnit * 3),
          TextField(
            controller: widget.model.questionController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Question',
              labelStyle: TextStyle(
                color: Colors.grey[800],
                fontFamily: 'OpenSans',
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.secondary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2.0,
                ),
              ),
            ),
            style: TextStyle(
              fontSize: Responsive.scale * 7,
              color: Colors.black87,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(height: Responsive.heightUnit * 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter the Options",
                style: TextStyle(
                  fontSize: Responsive.scale * 7,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: Responsive.heightUnit),
              Text(
                "Mark the right answer for your question",
                style: TextStyle(
                  fontSize: Responsive.scale * 7,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: Responsive.heightUnit * 5),
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.model.correctOptionIndex == index, // Static for now
                        onChanged: (val) {
                          if(val == true){
                            setState(() {
                              widget.model.correctOptionIndex = index;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: widget.model.optionControllers[index],
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: Responsive.scale * 7,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: Responsive.heightUnit * 3),
        ],
      ),
    );
  }
}
