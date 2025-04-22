import 'package:flutter/material.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/pages/score_page.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:quiz/database/quiz_database.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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
      appBar: AppBar(
        title: Text("Quiz Page"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GlobalUser().portions,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (quiz == null)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: quiz!.length,
                    itemBuilder: (context, index) {
                      final question = quiz![index];
                      final List<dynamic> option = question['Options'] ?? [];
                      final selected = selectedOptions[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index + 1}. ${question['question']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...option.map((opt) {
                            final optionText = opt['option'];
                            final isSelected = selected == optionText;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOptions[index] = opt['option'];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                  color: isSelected
                                      ? Colors.blue[100]
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  optionText,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      int score = calculateScore(selectedOptions);

                      int attemptLogId = await quizObject.updateQuizLog(GlobalUser().userId, GlobalUser().progress);

                      await quizObject.updateUserAnswers(attemptLogId, selectedOptions, quiz!);

                      await userDb.updateProgress(GlobalUser().progress + 1);

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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                  ),
                  child: Text(
                    "Submit Answers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
