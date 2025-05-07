import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz/utils/global_variables.dart';

class UserDatabase {
  final database = Supabase.instance.client;

  //Create
  Future createUser(String userEmail, String userName) async {
    await database.from('User').insert({
      'user_email': userEmail,
      'user_name': userName,
      'progress': 1,
    });
  }

  //Read
  Future<Map<String, dynamic>> getUserDetails(String currentUserEmail) async {
      final user = await database.from('User')
          .select('id, user_email, user_name, progress')
          .eq('user_email', currentUserEmail)
          .single();
      return user;
  }

  Future updateProgress(int progress) async {
    await database
        .from('User') // Use your actual table name here
        .update({'progress': progress})
        .eq('id', GlobalUser().userId); // Target a specific user row
  }

  Future<void> updateScore(int score) async {
    final userId = GlobalUser().userId;
    final response = await database
        .from('User')
        .select('score')
        .eq('id', userId)
        .single();

    if (response == null || response['score'] == null) {
      throw Exception("Failed to fetch current score");
    }

    final currentScore = response['score'] as int;

    // Step 2: Add new score
    final updatedScore = currentScore + score;

    // Step 3: Update the new score in the database
    await database
        .from('User')
        .update({'score': updatedScore})
        .eq('id', userId);
  }

  Future<int> getScore() async {
    final userId = GlobalUser().userId;

    final response = await database
        .from('User')
        .select('score')
        .eq('id', userId)
        .single();

    if (response == null || response['score'] == null) {
      print('Error: Could not retrieve score');
      return 0;
    }

    return response['score'] as int;
  }

}
