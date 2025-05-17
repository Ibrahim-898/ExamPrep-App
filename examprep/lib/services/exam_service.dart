import 'package:supabase_flutter/supabase_flutter.dart';

class ExamService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all live exams (current time within start & end time)
  static Future<List<Map<String, dynamic>>> fetchLiveExams() async {
    final now = DateTime.now().toUtc().toIso8601String();

    final response = await _client
        .from('live_exams')
        .select()
        .lte('start_time', now)
        .gte('end_time', now);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch all questions of a given exam
  static Future<List<Map<String, dynamic>>> fetchQuestions(String examId) async {
    final response = await _client
        .from('mcq_questions')
        .select()
        .eq('exam_id', examId);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Submit answers and calculate score
  static Future<void> submitAnswers({
    required String examId,
    required Map<String, String> answers,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    // Fetch correct answers
    final correctData = await _client
        .from('mcq_questions')
        .select('id, correct_answer')
        .eq('exam_id', examId);

    int total = correctData.length;
    int correct = 0;

    for (var q in correctData) {
      final qid = q['id'];
      final correctAnswer = q['correct_answer'];
      if (answers[qid] == correctAnswer) {
        correct++;
      }
    }

    final score = total == 0 ? 0 : (correct / total) * 100;

    // Insert submission
    await _client.from('exam_submissions').insert({
      'user_id': userId,
      'exam_id': examId,
      'answers': answers,
      'score': score,
    });
  }

  /// Fetch score after exam submission
  static Future<double?> fetchScore(String examId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('exam_submissions')
        .select('score')
        .eq('user_id', userId)
        .eq('exam_id', examId)
        .maybeSingle();

    return response?['score']?.toDouble();
  }
}
