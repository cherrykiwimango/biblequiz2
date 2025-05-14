import 'package:flutter/material.dart';
import 'package:quiz/utils/responsive.dart';
import 'package:quiz/database/quiz_database.dart';
import '../utils/colors.dart';
import '../utils/question_input.dart';
import '../utils/question_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final quizDatabase = QuizDatabase();
  TextEditingController dayController = TextEditingController();
  TextEditingController portionController = TextEditingController();

  List<QuestionModel> questions = List.generate(10, (_) => QuestionModel());
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create New Quiz",
          style: TextStyle(
              color: AppColors.primary,
              fontSize: Responsive.scale * 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter the Day and Portions",
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: Responsive.scale * 7,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans'),
                  ),
                ),
                SizedBox(
                  height: Responsive.heightUnit * 3,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Responsive.widthUnit * 23,
                      child: TextField(
                        controller: dayController,
                        decoration: InputDecoration(
                          labelText: 'Day',
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
                            fontFamily: 'OpenSans'),
                      ),
                    ),
                    SizedBox(
                      width: Responsive.widthUnit * 3,
                    ),
                    Expanded(
                      child: TextField(
                        controller: portionController,
                        decoration: InputDecoration(
                          labelText: 'Portions',
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
                            fontFamily: 'OpenSans'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Responsive.heightUnit * 8,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return QuestionInput(
                        index: index,
                        model: questions[index],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: Responsive.heightUnit * 8,
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null // Disable button while processing
                      : () async {
                          try {
                            setState(() {
                              isProcessing = true; // Set processing to true
                            });

                            int day = int.tryParse(dayController.text) ?? 0;
                            if (day == 0) {
                              throw 'Invalid day entered';
                            }
                            await quizDatabase.inputPortion(
                                day, portionController.text);

                            for (var q in questions) {
                              String question = q.questionController.text;
                              List<String> options = q.optionControllers
                                  .map((c) => c.text)
                                  .toList();
                              String correct = q
                                  .optionControllers[q.correctOptionIndex].text;

                              await quizDatabase.inputQuiz(
                                  day, question, correct, options);
                            }

                            // Show success confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content: Text(
                                      'Your questions have been uploaded successfully!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        // Clear the form fields after success
                                        setState(() {
                                          // Clear questions and inputs here
                                          dayController.clear();
                                          portionController.clear();
                                          for (var q in questions) {
                                            q.questionController.clear();
                                            for (var optionController
                                                in q.optionControllers) {
                                              optionController.clear();
                                            }
                                          }
                                        });
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            // Show error message if something goes wrong
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('An error occurred: $e'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } finally {
                            setState(() {
                              isProcessing =
                                  false; // Reset processing flag after the process is done
                            });
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                      padding: EdgeInsets.symmetric(
                          vertical: Responsive.heightUnit * 3,
                          horizontal: Responsive.widthUnit * 10),
                    ),
                  child: isProcessing
                      ? CircularProgressIndicator() // Show loading indicator while processing
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Submit',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: Responsive.scale * 10,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'OpenSans'),
                            ),
                          SizedBox(width: Responsive.widthUnit * 3),
                          Icon(
                            Icons.arrow_right_alt_sharp,
                            size: Responsive.heightUnit*5,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
