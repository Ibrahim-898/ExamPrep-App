import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DIPQuestionsPage extends StatefulWidget {
  const DIPQuestionsPage({super.key});

  @override
  State<DIPQuestionsPage> createState() => _DIPQuestionsPageState();
}

class _DIPQuestionsPageState extends State<DIPQuestionsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('DIPQuestionsPage initialized');
    fetchDIPQuestions();
  }

  Future<void> fetchDIPQuestions() async {
    try {
      debugPrint('Attempting to fetch DIP questions from Supabase...');
      debugPrint('Using table: short_questions');
      debugPrint('Filter: category = DIP');

      final response = await supabase
          .from('short_questions')
          .select()
          .eq('category', 'DIP');

      debugPrint('Supabase query completed');
      debugPrint('Number of DIP questions fetched: ${response.length}');

      if (response.isNotEmpty) {
        debugPrint('First DIP question sample: ${response.first}');
      }

      if (mounted) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
        debugPrint('State updated with ${questions.length} DIP questions');
      }
    } catch (error) {
      debugPrint('ERROR in fetchDIPQuestions: $error');
      debugPrint('Stack trace: ${error is Error ? (error).stackTrace : 'Not available'}');

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error: ${error.toString()}';
        });
        debugPrint('Error state set: $errorMessage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building DIP widget (isLoading: $isLoading, error: $errorMessage, questions: ${questions.length})');

    return Scaffold(
      appBar: AppBar(
        title: const Text("DIP Questions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint('Retry button pressed');
                          setState(() {
                            isLoading = true;
                            errorMessage = '';
                          });
                          fetchDIPQuestions();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : questions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No DIP questions found."),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('Retry button pressed (empty state)');
                              setState(() {
                                isLoading = true;
                              });
                              fetchDIPQuestions();
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        debugPrint('Rendering DIP question ${index + 1}/${questions.length}');
                        return Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ${question['question'] ?? 'No question'}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Answer: ${question['answer'] ?? 'No answer'}",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                SizedBox(height: 8),
                                if (question['difficulty'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "Difficulty: ${question['difficulty']}",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
