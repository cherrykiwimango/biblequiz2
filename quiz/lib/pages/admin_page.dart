import 'package:flutter/material.dart';
import 'package:quiz/pages/new_quiz.dart';
import 'package:quiz/utils/colors.dart';
import 'package:quiz/utils/responsive.dart';

import '../auth/auth_service.dart';
import 'log_in.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final authService = AuthService();
  void logout() async {
    await authService.signOut();

    // Navigate to login page and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
          (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.tertiary,),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Welcome Admin,",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: Responsive.scale * 10,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'OpenSans'
                  ),
                ),
              ),
              SizedBox(
                height: Responsive.heightUnit * 5,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: Responsive.heightUnit * 5,
                    horizontal: Responsive.widthUnit * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '20 Quizzers',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: Responsive.scale*14,
                            color: AppColors.primary,
                            fontFamily: 'OpenSans'
                          ),
                        ),
                        SizedBox(height: Responsive.heightUnit*2,),
                        Text(
                          'Logged in Yesterday',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Responsive.scale*8,
                            color: AppColors.primary,
                            fontFamily: 'OpenSans'
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orangeAccent,
                      size: Responsive.heightUnit*20,
                    )
                  ],
                ),
              ),
              SizedBox(height: Responsive.heightUnit*5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.heightUnit * 5,
                        horizontal: Responsive.widthUnit * 5),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.insert_chart_sharp,
                            size: Responsive.heightUnit*10,
                            color: Colors.white,
                          ),
                          SizedBox(height: Responsive.heightUnit*5,),
                          Text(
                            textAlign: TextAlign.center,
                            'Check Stats',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.scale*10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.widthUnit*3,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(),));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: Responsive.heightUnit * 5,
                          horizontal: Responsive.widthUnit * 5),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              size: Responsive.heightUnit*10,
                              color: Colors.white,
                            ),
                            SizedBox(height: Responsive.heightUnit*5,),
                            Text(
                              textAlign: TextAlign.center,
                              'Make New Quiz',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.scale*10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
