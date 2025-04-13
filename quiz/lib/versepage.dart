import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_html/flutter_html.dart';
import 'package:quiz/quizpage.dart';
import 'package:html/parser.dart' show parse;

class VersePage extends StatefulWidget {
  const VersePage({super.key, required this.portions});
  final String portions;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {

  String passageText = 'Loading...';
  String rawtext = "Loading...";

  @override
  void initState(){
    super.initState();
    fetchBiblePassage(widget.portions);
  }

  Future<void> fetchBiblePassage(String portions) async{
    final url = Uri.https('bible.oremus.org', '/', {
      'version': 'NRSV',
      'passage': portions,
    });
    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        final document = html_parser.parse(response.body);
        final bibleText = document.querySelector('.bibletext');

        final extractedText = bibleText?.text.trim() ?? "No content found";
        final htmlString = bibleText?.innerHtml ?? "No content found";
        String modifiedHtml = htmlString.replaceAllMapped(
          RegExp(r'<span[^>]*>LORD</span>', caseSensitive: false),
              (match) => 'LORD',
        );

        setState(() {
          passageText = modifiedHtml;
          rawtext = extractedText;
        });
      }
      else{
        setState(() {
          passageText = "Failed to load passage (status: ${response.statusCode})";
        });
      }
    }
    catch(e){
      setState(() {
        passageText = "Error: $e";
      });
    }
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
                  Text(
                    "Today's Bible Portion",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    widget.portions, //remember to add better formatting to this text
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Html(
                    data: passageText,
                    style: {
                      "span": Style(
                        fontSize: FontSize(30.0),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(right: 5),
                        display: Display.block
                      ),
                      "sup": Style(
                        fontSize: FontSize(16.0),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(right: 5),
                        display: Display.inlineBlock,
                      ),
                      "body": Style(
                          fontSize: FontSize(16.0),
                          fontWeight: FontWeight.normal,
                          lineHeight: LineHeight.number(1.4)
                      ),
                    },
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(passage: rawtext,),));
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
                      "Attempt Quiz",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
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
