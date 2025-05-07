import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/question_widget.dart';

class CheckPage extends StatefulWidget {
  const CheckPage(
      {super.key, required this.score, required this.selectedOptions});

  final int score;
  final Map<int, String> selectedOptions;

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final List<Map<String, dynamic>>? quiz = GlobalUser().quiz;
  PageController _pageController = PageController();
  // Map<int, String> selectedOptions = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Your Score: ${widget.score}/${quiz!.length}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.tertiary,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: (){
              Navigator.pop(context);
            },
          )
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (quiz == null)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: quiz!.length,
                    itemBuilder: (context, index) {
                      return QuestionCheckWidget(
                        questionData: quiz![index],
                        index: index,
                        totalQuestions: quiz!.length,
                        selectedOption: widget.selectedOptions[index] ?? "",
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
