import 'package:flutter/material.dart';
import 'package:quiz/auth/auth_service.dart';
import 'package:quiz/pages/admin_page.dart';
import 'package:quiz/pages/sign_up.dart';
import 'package:quiz/utils/colors.dart';
import 'package:quiz/utils/responsive.dart';

import 'main_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _obscureText = true;
  final authService = AuthService();

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
      if(email == 'vsajujacob@gmail.com'){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
              (Route<dynamic> route) => false,
        );
      }
      else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Log In",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: Responsive.scale*14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'OpenSans'
                ),
              ),
              SizedBox(
                height: Responsive.heightUnit*3,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "New around here? ",
                        style: TextStyle(
                          fontSize: Responsive.scale*7,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans'
                        )),
                    TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          fontSize: Responsive.scale*7,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'OpenSans'
                        )),
                  ]),
                ),
              ),
              SizedBox(
                height: Responsive.heightUnit*12,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.primary, fontFamily: 'OpenSans', ),
                    hintText: 'Enter your text',
                    hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'OpenSans', ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: Responsive.scale*7,
                    color: Colors.black87,
                    fontFamily: 'OpenSans'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.primary, fontFamily: 'OpenSans', ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'OpenSans', ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: Responsive.scale*7,
                      color: Colors.black87,
                      fontFamily: 'OpenSans'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
                  ),
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.scale*9,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'OpenSans'
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
