import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz/auth/auth_service.dart';
import 'package:quiz/database/quiz_database.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/pages/quiz_page.dart';
import 'package:quiz/utils/global_variables.dart';
import 'package:quiz/utils/colors.dart';
import 'log_in.dart';
import 'package:quiz/utils/responsive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  final List<String> _profileImages = [
    'assets/saint1.jpg',
    'assets/saint2.jpg',
    'assets/saint3.jpg',
    'assets/saint4.jpg',
    'assets/saint5.jpg',
    'assets/saint6.jpg',
  ];

  String _selectedProfileImage = 'assets/saint1.jpg';

  final authService = AuthService();
  final database = UserDatabase();
  final quizDatabase = QuizDatabase();

  late int totalScore = 0;

  //logout function
  void logout() async {
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
    final Map<String, dynamic> data =
        await database.getUserDetails(currentUserEmail);
    GlobalUser().updateFromMap(data);
    GlobalUser().updateCurrentDay();

    (GlobalUser().progress > GlobalUser().currentDay)
        ? day = GlobalUser().currentDay
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

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a Profile Image',
                  style: TextStyle(
                    fontSize: Responsive.scale*8,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      for (var imagePath in _profileImages)
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              GlobalUser().profile = imagePath;
                            });
                            await database.updateProfile(imagePath);
                            Navigator.pop(context); // Close dialog
                          },
                          child: ClipOval(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    logout();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Responsive.heightUnit*5, horizontal: Responsive.widthUnit*5),
                    backgroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: AppColors.tertiary,
                          fontSize: Responsive.scale*9,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      SizedBox(width: Responsive.widthUnit*5,),
                      Icon(
                        Icons.logout,
                        color: AppColors.tertiary,
                        size: Responsive.heightUnit*5,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    if (_isLoading) {
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
          padding: EdgeInsets.symmetric(
              vertical: Responsive.heightUnit * 7,
              horizontal: Responsive.widthUnit * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey ${GlobalUser().name},",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: Responsive.scale * 12.5,
                              fontFamily: 'OpenSans'),
                        ),
                        SizedBox(height: Responsive.heightUnit * 1.5),
                        Text(
                          "Welcome back, Let's get started",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.scale * 7,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showImagePickerDialog(context),
                    child: ClipOval(
                      child: Image.asset(
                        GlobalUser().profile,
                        width: Responsive.heightUnit * 20,
                        height: Responsive.heightUnit * 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.secondary,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.widthUnit * 5,
                        vertical: Responsive.heightUnit * 8),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.barsProgress,
                                color: AppColors.accent,
                                size: Responsive.heightUnit * 7,
                              ),
                              SizedBox(
                                width: Responsive.widthUnit * 4,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day ${GlobalUser().progress}",
                                    style: TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Responsive.scale * 11,
                                        fontFamily: 'OpenSans'),
                                  ),
                                  SizedBox(
                                    height: Responsive.heightUnit,
                                  ),
                                  Text(
                                    "Your Progress",
                                    style: TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Responsive.scale * 6,
                                        fontFamily: 'OpenSans'),
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
                              Icon(
                                FontAwesomeIcons.calendarDay,
                                color: AppColors.primary,
                                size: Responsive.heightUnit * 7,
                              ),
                              SizedBox(
                                width: Responsive.widthUnit * 4,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day ${GlobalUser().currentDay}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Responsive.scale * 11,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  SizedBox(
                                    height: Responsive.heightUnit,
                                  ),
                                  Text(
                                    "Current Day",
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Responsive.scale * 6,
                                        fontFamily: 'OpenSans'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.heightUnit * 3,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.secondary)),
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.heightUnit * 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Total Score',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Responsive.scale*8,
                                  fontFamily: 'OpenSans',
                                  color: AppColors.primary),
                            ),
                            Row(
                              children: [
                                Text("$totalScore",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                        fontFamily: 'OpenSans',
                                        fontSize: Responsive.scale * 25)),
                                Text("/${GlobalUser().currentDay * 10}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'OpenSans',
                                        color: AppColors.primary,
                                        fontSize: Responsive.scale * 13)),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: Responsive.heightUnit * 42,
                          height: Responsive.heightUnit * 42,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Background trophy with lower opacity
                              Opacity(
                                opacity: 0.3,
                                child: SvgPicture.asset(
                                  'assets/trophy-svgrepo-com.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // Clipped foreground trophy to simulate fill
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: (totalScore / (GlobalUser().currentDay * 10)).clamp(0.0, 1.0),
                                  child: SvgPicture.asset(
                                    'assets/trophy-svgrepo-com.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Responsive.heightUnit * 5,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.new_releases_rounded,
                            color: AppColors.tertiary,
                          ),
                          SizedBox(
                            width: Responsive.widthUnit,
                          ),
                          Text(
                            "Today's Portion",
                            style: TextStyle(
                              color: AppColors.tertiary,
                              fontSize: Responsive.scale * 8,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'OpenSans'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.heightUnit * 2,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: Responsive.heightUnit * 5,
                            horizontal: Responsive.widthUnit * 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.error,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          GlobalUser().portions,
                          style: TextStyle(
                            color: AppColors.tertiary,
                            fontSize: Responsive.scale * 10,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'OpenSans'
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  backgroundColor:
                      GlobalUser().progress > GlobalUser().currentDay
                          ? Colors.grey[400]
                          : AppColors.secondary,
                  foregroundColor:
                      GlobalUser().progress > GlobalUser().currentDay
                          ? Colors.grey[800]
                          : AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: GlobalUser().progress > GlobalUser().currentDay
                            ? Colors
                                .grey[600]! // add ! since grey[600] is Color?
                            : AppColors.primary,
                      )),
                  padding: EdgeInsets.symmetric(
                      vertical: Responsive.heightUnit * 5,
                      horizontal: Responsive.widthUnit * 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GlobalUser().progress > GlobalUser().currentDay
                          ? "Come back"
                          : "Attempt Quiz",
                      style: TextStyle(
                        fontSize: Responsive.scale * 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'OpenSans',
                        color:  GlobalUser().progress > GlobalUser().currentDay? Colors.grey[500]: AppColors.primary
                      ),
                    ),
                    SizedBox(width: Responsive.widthUnit * 3),
                    Icon(
                      Icons.arrow_right_alt_sharp,
                      size: 30,
                      color: GlobalUser().progress > GlobalUser().currentDay? Colors.grey[500]: AppColors.primary,
                    ),
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
