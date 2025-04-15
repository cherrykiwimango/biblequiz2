import 'package:supabase_flutter/supabase_flutter.dart';

class UserDatabase {
  final database = Supabase.instance.client.from('User');

  //Create
  Future createUser(String userEmail, String userName) async {
    await database.insert({
      'user_email': userEmail,
      'user_name': userName,
      'progress': 1,
    });
  }

  //Read
  Future<Map<String, dynamic>> getUserDetails(String currentUserEmail) async {
      final user = await database
          .select('user_email, user_name, progress')
          .eq('user_email', currentUserEmail)
          .single();
      return user;
  }

  Future updateProgress(int progress) async{
    await database.update({
      'progress': progress,
    });
  }
}
