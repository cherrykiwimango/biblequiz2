import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/pages/main_page.dart';
import '../utils/list_question_item.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.passage});
  final String passage;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? quiz = 'Loading...';
  //problem line
  List<Map<String, dynamic>> quizList = [];

  //function to generate quiz
  Future<void> generateQuiz(String passage) async {
    final url = Uri.parse("http://192.168.255.11:8000/generate-quiz");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'passage': passage}),
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> quizData;
      try {
        final data = jsonDecode(response.body);
        quizData = List<Map<String, dynamic>>.from(data['questions']);
      } catch (e) {
        quizData = [
          {
            "question": "What is the capital of France?",
            "options": ["Paris", "Berlin", "Madrid", "Rome"],
            "answer": "Paris"
          },
          {
            "question": "Who developed the theory of relativity?",
            "options": ["Isaac Newton", "Albert Einstein", "Marie Curie", "Nikola Tesla"],
            "answer": "Albert Einstein"
          },
        ];
        print('Error decoding JSON: $e');
      }
      setState(() {
        quizList = quizData;
      });
      print("Quiz fetched successfully!");
    } else {
      print("Error fetching the response: ${response.statusCode}");
      setState(() {
        quiz = "Error fetching quiz";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateQuiz(widget.passage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Quiz Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  quizList.isEmpty
                      ? Center(child: Text("Loading"))
                      : Column(
                    children: quizList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListQuestion(
                          question: item["question"],
                          options: item["options"],
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
                      ),
                      child: Text(
                        "Go Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
