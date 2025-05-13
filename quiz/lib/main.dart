import 'package:flutter/material.dart';
import 'package:quiz/auth/auth_gate.dart';
import 'package:quiz/pages/main_page.dart';
import 'package:quiz/pages/sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  //supabase setup
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qbmFhd2hwcWhxZXNtdmFhdmZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MDk5MTEsImV4cCI6MjA2MDE4NTkxMX0.v9pb__4gt9obDIoevGj-V35fPhmCcYvDzIfwZ8wcwhk",
    url: "https://ojnaawhpqhqesmvaavfl.supabase.co",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height), // your design reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}