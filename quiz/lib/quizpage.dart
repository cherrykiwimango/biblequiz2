import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_html/flutter_html.dart';
import 'utils/ListQuestion.dart';

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Quiz Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.black,
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

}
