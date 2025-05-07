import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz/pages/check_page.dart';
import 'package:quiz/pages/main_page.dart';
import 'package:quiz/utils/colors.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:lottie/lottie.dart';

class ScorePage extends StatefulWidget {
  const ScorePage(
      {super.key, required this.selectedOptions, required this.score});

  final Map<int, String> selectedOptions;
  final int score;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/Animation - 1746595557545.json',
              width: 1000,
              height: 1000,
              repeat: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80, bottom: 25, left: 25, right: 25),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/trophy-svgrepo-com.svg',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(height: 30,),
                        RichText(
                          text: TextSpan(
                            text: 'Your ',
                            style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w800, fontFamily: 'OpenSans'),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Final Score !',
                                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.score < 4 ? "Try harder next time" : "Great job! See you next time",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 30),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 140,
                              width: 140,
                              child: CircularProgressIndicator(
                                value: widget.score / GlobalUser().quiz!.length,
                                strokeWidth: 9,
                                backgroundColor: AppColors.neutral,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: '${widget.score}',
                                    style: TextStyle(color: AppColors.primary, fontSize: 42, fontWeight: FontWeight.w800, fontFamily: 'OpenSans'),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '/${GlobalUser().quiz!.length}',
                                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Day ${GlobalUser().progress}",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckPage(
                                      score: widget.score,
                                      selectedOptions: widget.selectedOptions),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding:
                            EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                          ),
                          child: Text(
                            "Check Answers",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalUser().progress > GlobalUser().currentDay
                          ? Colors.grey[400]
                          : AppColors.secondary,
                      foregroundColor: GlobalUser().progress > GlobalUser().currentDay
                          ? Colors.grey[800]
                          : AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: AppColors.primary)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Go Home",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_right_alt_sharp, color: AppColors.primary, size: 30,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
