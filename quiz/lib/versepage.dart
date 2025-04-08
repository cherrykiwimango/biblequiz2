import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class VersePage extends StatefulWidget {
  const VersePage({super.key});

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {

  String passagetext = 'Loading...';

  @override
  void initState(){
    super.initState();
    fetchBiblePassage();
  }

  Future<void> fetchBiblePassage() async{
    final url = Uri.parse('http://bible.oremus.org/?version=NRSV&passage=Luke%202-3');
    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        final document = html_parser.parse(response.body);
        final extractedText = document.body?.text ?? "No content found";

        setState(() {
          passagetext = extractedText;
        });
      }
      else{
        setState(() {
          passagetext = "Failed to load passage (status: ${response.statusCode})";
        });
      }
    }
    catch(e){
      setState(() {
        passagetext = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Center(
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
                "LUKE chapters 3 - 5", //remember to add better formatting to this text
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                passagetext,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
