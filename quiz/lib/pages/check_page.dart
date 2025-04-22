import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

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
  // Map<int, String> selectedOptions = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check page"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Score: ${widget.score}/${quiz!.length}",
                  style: TextStyle(
                    fontSize: 26,
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
                      final selected = widget.selectedOptions[index];

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
                            bool isCorrect = false;
                            bool isSelected = false;
                            if(optionText == question['answer']){
                              isCorrect = true;
                            }
                            if(optionText == selected){
                              isSelected = true;
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                ?isCorrect?Colors.green[100]:Colors.red[100]
                                :Colors.transparent,
                              ),
                              child: Text(
                                optionText,
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          Text(
                            "Answer: ${question['answer']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
