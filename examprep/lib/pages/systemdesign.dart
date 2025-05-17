import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SystemDesignQuestionsPage extends StatefulWidget {
  const SystemDesignQuestionsPage({super.key});

  @override
  State<SystemDesignQuestionsPage> createState() => _SystemDesignQuestionsPageState();
}

class _SystemDesignQuestionsPageState extends State<SystemDesignQuestionsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('SystemDesignQuestionsPage initialized');
    fetchSystemDesignQuestions();
  }

  Future<void> fetchSystemDesignQuestions() async {
    try {
      debugPrint('Attempting to fetch questions from Supabase...');
      debugPrint('Using table: short_questions');
      debugPrint('Filter: catagory = SystemDesign');

      final response = await supabase
          .from('short_questions')
          .select()
          .eq('category', 'SystemDesign');

      debugPrint('Supabase query completed');
      debugPrint('Number of questions fetched: ${response.length}');
      
      if (response.isNotEmpty) {
        debugPrint('First question sample: ${response.first}');
      }

      if (mounted) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
        debugPrint('State updated with ${questions.length} questions');
      }
    } catch (error) {
      debugPrint('ERROR in fetchSystemDesignQuestions: $error');
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
    debugPrint('Building widget (isLoading: $isLoading, error: $errorMessage, questions: ${questions.length})');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Design Questions"),
        backgroundColor: Colors.teal,
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
                          fetchSystemDesignQuestions();
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
                          Text("No questions found for 'SystemDesign'."),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('Retry button pressed (empty state)');
                              setState(() {
                                isLoading = true;
                              });
                              fetchSystemDesignQuestions();
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
                        debugPrint('Rendering question ${index + 1}/${questions.length}');
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
                                  style: TextStyle(color: Colors.green),
                                ),
                                SizedBox(height: 8),
                              
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}