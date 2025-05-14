/*
Continuously listen for auth state changes.
_________________________________________________

unauthenticated -> Login Page
authenticated -> Main Page

 */

import 'package:flutter/material.dart';
import 'package:quiz/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/admin_page.dart';
import '../pages/log_in.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      //Build appropriate page based on the auth state
      builder: (context, snapshot) {
        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //if there's a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if(session != null){
          final userEmail = session.user.email;
          if(userEmail == 'vsajujacob@gmail.com'){
            return const AdminHome();
          }
          else{
            return const MyHomePage();
          }
        }
        else{
          return const LogIn();
        }
      },
    );
  }
}
