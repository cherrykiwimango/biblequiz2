import 'package:flutter/material.dart';
import 'package:quiz/auth/auth_service.dart';
import 'package:quiz/database/quiz_database.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:quiz/versepage.dart';
import 'package:quiz/utils/bible_portions_manager.dart';

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

  void logout() async{
    await authService.signOut();
  }

  Future<void> _loadInfo() async {
    int day;

    final String currentUserEmail = authService.getCurrentUserEmail() ?? '';
    final Map<String, dynamic> data = await database.getUserDetails(currentUserEmail);
    GlobalUser().updateFromMap(data);
    GlobalUser().updateCurrentDay();

    (GlobalUser().progress > GlobalUser().currentDay)?
    day = GlobalUser().currentDay
    : day = GlobalUser().progress;


    GlobalUser().portions = await quizDatabase.getPortion(day) ?? 'Unavailable';
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
      appBar: AppBar(
        title: Text("Standby"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VersePage(
                                portions: BiblePortionManager.portionsForToday(),
                              ),
                            ));
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
                        "Experimental",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text(
                    "Welcome ${GlobalUser().name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Today: Day ${GlobalUser().currentDay}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text(
                    "Progess: Day ${GlobalUser().progress}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    GlobalUser().portions,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    "this is the main page of the app",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
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
                  "Attempt Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
