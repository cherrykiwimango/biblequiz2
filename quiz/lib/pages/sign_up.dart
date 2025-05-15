import 'package:flutter/material.dart';
import 'package:quiz/auth/auth_service.dart';
import 'package:quiz/database/user_database.dart';
import 'package:quiz/pages/log_in.dart';
import 'package:quiz/utils/colors.dart';

import '../utils/responsive.dart';
import 'main_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final authService = AuthService();
  final database = UserDatabase();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;

  void signUp() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    if (name == null || name.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Name can't be empty")));
      return;
    }
    try {
      await authService.signUpWithEmailPassword(email, password);
      await database.createUser(email, name);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logobible2.png', width: Responsive.heightUnit*40,),
              SizedBox(height: Responsive.heightUnit*10),
              Text(
                "Sign Up",
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
                        builder: (context) => LogIn(),
                      ));
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Already have an Account? ",
                        style: TextStyle(
                            fontSize: Responsive.scale*7,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans'
                        )),
                    TextSpan(
                        text: "Log In",
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: AppColors.primary, fontFamily: 'OpenSans', ),
                    hintText: 'Enter your name',
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
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText2
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: AppColors.primary, fontFamily: 'OpenSans', ),
                    hintText: 'Match the above password',
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
                  onPressed: signUp,
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
                    "Sign Up",
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
