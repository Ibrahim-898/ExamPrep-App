import 'package:flutter/material.dart';
import 'package:examprep/services/exam_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double? score;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final examId = args['examId'] as String;
    loadScore(examId);
  }

  Future<void> loadScore(String examId) async {
    final fetchedScore = await ExamService.fetchScore(examId);
    setState(() {
      score = fetchedScore;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Your Exam Result')),
      body: Center(
        child: score == null
            ? const Text('No result found.')
            : Text(
                'Your score: ${score!.toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
