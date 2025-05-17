import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  final Map<int, String> selectedAnswers = {};
  int score = 0;
  bool examStarted = false;
  bool examEnded = false;
  DateTime? startTime;
  DateTime? endTime;
  late CountdownTimerController timerController;
  bool isLoading = false;

  @override
  void dispose() {
    timerController.dispose();
    super.dispose();
  }
  Future<void> startExam() async {
  setState(() => isLoading = true);
  
  try {
    // Method 1: Using SQL RANDOM() via rpc (most efficient)
    final response = await Supabase.instance.client
        .rpc('get_random_questions', params: {'limit_count': 10})
        .timeout(const Duration(seconds: 10));



    if (!mounted) return;
    
    setState(() {
      questions = List<Map<String, dynamic>>.from(response);
      examStarted = true;
      isLoading = false;
      startTime = DateTime.now();
      timerController = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch + 600 * 1000,
        onEnd: endExam,
      );
    });

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
    setState(() => isLoading = false);
  }
}

 
   void endExam() {
  setState(() {
    examEnded = true;
    endTime = DateTime.now();
    
    score = questions.where((q) {
      final selected = selectedAnswers[q['id']];
      if (selected == null) return false;
      final correctIndex = q['correct_answer_index'] as int? ?? -1;
      return selected.codeUnitAt(0) - 97 == correctIndex; // 'a'=97 → 0, 'b'=98 → 1
    }).length;
  });
}
 void selectAnswer(String answer) {
  setState(() {
    // Only allow setting answer if not already set
    if (!selectedAnswers.containsKey(questions[currentIndex]['id'])) {
      selectedAnswers[questions[currentIndex]['id']] = answer;
      
      // Auto-advance to next question if not the last one
      if (currentIndex < questions.length - 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => currentIndex++);
          Scrollable.ensureVisible(context);
        });
      }
    }
  });
}
  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'MCQ Exam',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'You will have 10 minutes to answer 10 questions',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: isLoading ? null : startExam,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Start Exam', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }


Widget _buildQuestion() {
  final question = questions[currentIndex];
  final options = List<String>.from(question['options'] ?? []);
  final questionText = question['question'] as String? ?? 'Question not available';
   final isAnswered = selectedAnswers.containsKey(question['id']);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Timer and progress indicators
      CountdownTimer(
        controller: timerController,
        widgetBuilder: (_, time) {
          if (time == null) {
            return const Text(
              'Time expired!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            );
          }
          return Text(
            'Time left: ${time.min ?? 0}:${time.sec?.toString().padLeft(2, '0') ?? '00'}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        },
      ),
      const SizedBox(height: 20),
      LinearProgressIndicator(
        value: (currentIndex + 1) / questions.length,
        minHeight: 10,
        backgroundColor: Colors.grey[200],
        color: Colors.blue,
      ),
      const SizedBox(height: 20),
      Text(
        'Question ${currentIndex + 1}/${questions.length}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            questionText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      const SizedBox(height: 30),
       Expanded(
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final optionLetter = String.fromCharCode(97 + index);
            final isSelected = selectedAnswers[question['id']] == optionLetter;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue[200] : null,
                  foregroundColor: isAnswered && !isSelected ? Colors.grey : null,
                ),
                onPressed: isAnswered 
                    ? null // Disable if already answered
                    : () => selectAnswer(optionLetter),
                child: Text(options[index]),
              ),
            );
          },
        ),
      ),
      // Navigation Buttons
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            ElevatedButton(
              onPressed: currentIndex > 0 ? () {
                setState(() => currentIndex--);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(context);
                });
              } : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
              ),
              child: const Text('Previous'),
            ),

            // Next/Submit Button
            ElevatedButton(
              onPressed: () {
                if (currentIndex < questions.length - 1) {
                  setState(() => currentIndex++);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scrollable.ensureVisible(context);
                  });
                } else {
                  endExam();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
              ),
              child: Text(
                currentIndex < questions.length - 1 ? 'Next' : 'Submit',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  
      

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Exam Completed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Score: $score/${questions.length}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Started at:', style: TextStyle(fontSize: 14)),
                          Text(
                            DateFormat('HH:mm:ss').format(startTime!),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Ended at:', style: TextStyle(fontSize: 14)),
                          Text(
                            DateFormat('HH:mm:ss').format(endTime!),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
               const Text('Review Answers:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final options = List<String>.from(question['options'] ?? []);
          final correctIndex = question['correct_answer_index'] as int? ?? -1;
          final correctAnswer = correctIndex >= 0 && correctIndex < options.length 
              ? options[correctIndex] 
              : 'Not available';
          final userAnswerLetter = selectedAnswers[question['id']];
          final userAnswer = userAnswerLetter != null && userAnswerLetter.codeUnitAt(0) - 97 < options.length
              ? options[userAnswerLetter.codeUnitAt(0) - 97]
              : 'Not answered';

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ${question['question'] ?? 'Question not available'}'),
                  const SizedBox(height: 8),
                  Text('Your answer: $userAnswer',
  style: TextStyle(
    color: (userAnswerLetter != null && 
           userAnswerLetter.isNotEmpty &&
           userAnswerLetter.codeUnitAt(0) - 97 == correctIndex)
        ? Colors.green
        : Colors.red,
  ),
),
                  Text('Correct answer: $correctAnswer'),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}
                    
         

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Exam'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !examStarted 
            ? _buildStartScreen() 
            : examEnded 
                ? _buildResults() 
                : _buildQuestion(),
      ),
    );
  }
}