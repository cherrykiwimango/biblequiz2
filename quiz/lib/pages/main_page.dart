import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz/auth/auth_service.dart';
import 'package:quiz/database/quiz_database.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/pages/quiz_page.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:quiz/pages/versepage.dart';
import 'package:quiz/utils/bible_portions_manager.dart';
import 'package:quiz/utils/colors.dart';
import 'log_in.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;

  final authService = AuthService();
  final database = UserDatabase();
  final quizDatabase = QuizDatabase();

  late int totalScore = 0;

  //logout function
  void logout() async{
    await authService.signOut();

    // Navigate to login page and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
          (route) => false,
    );
  }

  //update global variables on page reload
  Future<void> _loadInfo() async {
    int day;

    final String currentUserEmail = authService.getCurrentUserEmail() ?? '';
    final Map<String, dynamic> data = await database.getUserDetails(currentUserEmail);
    GlobalUser().updateFromMap(data);
    GlobalUser().updateCurrentDay();

    (GlobalUser().progress > GlobalUser().currentDay)?
    day = GlobalUser().currentDay
    : day = GlobalUser().progress;
    
    totalScore = await database.getScore();
    
    GlobalUser().portions = await quizDatabase.getPortion(day) ?? 'Unavailable';
    GlobalUser().quiz = await quizDatabase.getQuiz(day);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey ${GlobalUser().name},",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Welcome back, Let's get started",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: logout,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/chad.png',
                              width: 77,
                              height: 77,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  //the top blue box
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.secondary,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.barsProgress, color: AppColors.accent, size: 35,),
                              SizedBox(width: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day ${GlobalUser().progress}",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    "Your Progress",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                            width: 20, //
                          ),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.calendarDay, color: AppColors.primary, size: 35,),
                              SizedBox(width: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day ${GlobalUser().currentDay}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    "Current Day",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                    child: IntrinsicHeight(
                      child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Your ',
                            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Total Score',
                                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 140,
                              width: 140,
                              child: CircularProgressIndicator(
                                value: 7 / 10,
                                strokeWidth: 9,
                                backgroundColor: AppColors.neutral,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                            Column(
                              children: [
                                Text("${totalScore}", style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 36)),
                                Text("/${GlobalUser().currentDay * 10}", style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 24)),
                              ],
                            ),
                          ],
                        )
                      ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.new_releases_rounded, color: AppColors.tertiary,),
                          SizedBox(width: 10,),
                          Text(
                            "Today's Portion",
                            style: TextStyle(
                              color: AppColors.tertiary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.error,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          GlobalUser().portions,
                          style: TextStyle(
                            color: AppColors.tertiary,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: 30,),
              ElevatedButton(
                onPressed: GlobalUser().progress > GlobalUser().currentDay
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Quiz()),
                  );
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
                      "Attempt Quiz",
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
    );
  }
}
