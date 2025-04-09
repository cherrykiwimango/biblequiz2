import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_html/flutter_html.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.passage});
  final String passage;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? quiz = 'Loading...';

  Future<String?> generateQuiz(String passage) async{
    const apiKey = 'AIzaSyAyQmXBKCIXn4w5WUnJYVaxlqJES9Z0wwk';
    const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

    final headers = {
      'Content-type': 'application/json',
    };

    final prompt = '''
    Make a 5-question multiple choice quiz based on the following passage. 
    Each question should have 4 options and indicate the correct answer at the end.
    Passage: 
    $passage
    ''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });

    try{
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final quiz = data['candidates'][0]['content']['parts'][0]['text'];
        return quiz;
      }
      else{
        print("Error: ${response.statusCode}");
        print(response.body);
        return null;
      }
    }
    catch(e){
      print("Exception: $e");
      return null;
    }
  }

  Future<void> generateAndSet() async{
    final generated = await generateQuiz(widget.passage);
    setState(() {
      quiz = generated;
    });
  }

  @override
  void initState() {
    super.initState();
    generateAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("There is gonna be text here"),
                  Text(
                    quiz ?? "Generating quiz...",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
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
