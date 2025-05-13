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
      print("Error: $e"); // remove this later
      return null;
    }
  }

  /*fetch answer

  handle function elsewhere: if function returns null
  then display block saying "quiz unavailable"

  */

  Future<List<Map<String, dynamic>>?> getQuiz(int day) async {
    try {
      final dayIdResponse =
          await database.from('Portions').select('id').eq('day', day).single();
      final dayId = dayIdResponse['id'] as int;

      final response = await database
          .from('Questions')
          .select('id, question, answer, Options(option)')
          .eq('day_id', dayId);
      return response;
    } catch (e) {
      print("Error: $e"); //remove this later
      return null;
    }
  }

  Future<int> updateQuizLog(int currentUserId, int currentDay) async {
    //Getting the currentDay id
    final dayIdResponse = await database
        .from('Portions')
        .select('id')
        .eq('day', currentDay)
        .single();
    final dayId = dayIdResponse['id'] as int;

    //updating the Attempt_Log
    final attemptLogResponse = await database
        .from('Attempt_Log')
        .insert({
          'user_id': currentUserId,
          'day_id': dayId,
        })
        .select()
        .single();

    final attemptLogId = attemptLogResponse['id'] as int;
    return attemptLogId;
  }

  Future<void> updateUserAnswers(int attemptLogId,
      Map<int, String> selectedOptions, List<Map<String, dynamic>> quiz) async {
    // Create a list of maps to insert into the user_answers table
    final List<Map<String, dynamic>> answersToInsert = [];

    selectedOptions.forEach((index, selectedAnswer) {
      final question = quiz[index]; // get question from quiz list
      final questionId = question['id']; // assuming each question has an 'id'

      answersToInsert.add({
        'attempt_log_id': attemptLogId,
        'question_id': questionId,
        'answer': selectedAnswer,
      });
    });

    if (answersToInsert.isNotEmpty) {
      await database.from('User_Answers').insert(answersToInsert);
    }
  }

  Future<void> inputPortion(int day, String portion) async {
    await database.from('Portions').insert({
      'day': day,
      'portion': portion,
    });
  }

  Future<void> inputQuiz(
      int day, String question, String answer, List<String> options) async {
    final dayIdResponse =
        await database.from('Portions').select('id').eq('day', day).single();
    final dayId = dayIdResponse['id'] as int;

    final response = await database.from('Questions').insert({
      'day_id': dayId,
      'question': question,
      'answer': answer,
    }).select().single();

    final questionId = response['id'];
    for(var option in options){
      await database.from('Options').insert({
        'question_id': questionId,
        'option': option,
      });
    }
  }
}
