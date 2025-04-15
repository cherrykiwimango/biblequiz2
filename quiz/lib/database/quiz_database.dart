import 'package:supabase_flutter/supabase_flutter.dart';

class QuizDatabase {
  final database = Supabase.instance.client;

  //fetch portions
  Future<String?> getPortion(int day) async {
    try {
      final response = await database
          .from('Portions')
          .select('portion')
          .eq('day', day)
          .single();
      return response['portion'] as String;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /*fetch answer

  handle function elsewhere: if function returns null
  then display block saying "quiz unavailable"

  */
  Future<List<Map<String, dynamic>>?> getQuiz(int day) async {
    try
    {
      final dayIdResponse =
          await database.from('Portions').select('id').eq('day', day).single();
      final dayId = dayIdResponse['id'] as int;

      final response = await database
          .from('Questions')
          .select('id, question, answer, Options(id, option)')
          .eq('day_id', dayId);
      return response;
    }
    catch(e){
      print("Error: $e");
      return null;
    }
  }
}
