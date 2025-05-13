import 'package:flutter/material.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/pages/score_page.dart';
import 'package:quiz/utils/colors.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:quiz/database/quiz_database.dart';
import 'package:quiz/utils/responsive.dart';

import '../utils/question_widget.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  PageController _pageController = PageController();
  final List<Map<String, dynamic>>? quiz = GlobalUser().quiz;
  Map<int, String> selectedOptions = {};

  final quizObject = QuizDatabase();
  final userDb = UserDatabase();

  int calculateScore(Map<int, String> selectedOptions) {
    int score = 0;
    for (int i = 0; i < quiz!.length; i++) {
      if (selectedOptions[i] == quiz![i]['answer']) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: Responsive.heightUnit * 20,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              GlobalUser().portions,
              style: TextStyle(
                fontSize: Responsive.scale * 9,
                fontWeight: FontWeight.w800,
                color: AppColors.tertiary,
                fontFamily: 'OpenSans'
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.widthUnit * 5,
              vertical: Responsive.heightUnit * 7),
          child: Column(
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
                      return QuestionWidget(
                        questionData: quiz![index],
                        index: index,
                        totalQuestions: quiz!.length,
                        selectedOption: selectedOptions[index] ?? "",
                        onOptionSelected: (option) {
                          setState(() {
                            selectedOptions[index] = option;
                          });
                        },
                      );
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  final isLastPage = _pageController.page?.round() == quiz!.length - 1;

                  if (!isLastPage) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    try {
                      int score = calculateScore(selectedOptions);

                      int attemptLogId = await quizObject.updateQuizLog(
                          GlobalUser().userId, GlobalUser().progress);

                      await quizObject.updateUserAnswers(
                          attemptLogId, selectedOptions, quiz!);

                      await userDb.updateProgress(GlobalUser().progress + 1);
                      await userDb.updateScore(score);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScorePage(
                            selectedOptions: selectedOptions,
                            score: score,
                          ),
                        ),
                      );
                    } catch (e, stack) {
                      print('❌ Error occurred: $e');
                      print('🧱 Stack trace: $stack');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Something went wrong: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: AppColors.primary)),
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.heightUnit * 4,
                    horizontal: Responsive.widthUnit * 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _pageController.hasClients &&
                          _pageController.page?.round() == quiz!.length - 1
                          ? "Submit"
                          : "Next",
                      style: TextStyle(
                          fontSize: Responsive.scale * 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          color: AppColors.primary),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      _pageController.hasClients &&
                          _pageController.page?.round() == quiz!.length - 1
                          ? Icons.check
                          : Icons.arrow_right_alt_sharp,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
