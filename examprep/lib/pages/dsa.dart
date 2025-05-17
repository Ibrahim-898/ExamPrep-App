import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DSAQuestionsPage extends StatefulWidget {
  const DSAQuestionsPage({super.key});

  @override
  State<DSAQuestionsPage> createState() => _DSAQuestionsPageState();
}

class _DSAQuestionsPageState extends State<DSAQuestionsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('DSAQuestionsPage initialized');
    fetchDSAQuestions();
  }

  Future<void> fetchDSAQuestions() async {
    try {
      debugPrint('Attempting to fetch DSA questions from Supabase...');
      debugPrint('Using table: short_questions');
      debugPrint('Filter: category = DSA');

      final response = await supabase
          .from('short_questions')
          .select()
          .eq('category', 'DSA');  // Changed to filter for DSA questions

      debugPrint('Supabase query completed');
      debugPrint('Number of DSA questions fetched: ${response.length}');
      
      if (response.isNotEmpty) {
        debugPrint('First DSA question sample: ${response.first}');
      }

      if (mounted) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
        debugPrint('State updated with ${questions.length} DSA questions');
      }
    } catch (error) {
      debugPrint('ERROR in fetchDSAQuestions: $error');
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
    debugPrint('Building DSA widget (isLoading: $isLoading, error: $errorMessage, questions: ${questions.length})');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("DSA Questions"),
        backgroundColor: Colors.blue,  // Changed to blue for DSA
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
                          fetchDSAQuestions();
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
                          Text("No DSA questions found."),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('Retry button pressed (empty state)');
                              setState(() {
                                isLoading = true;
                              });
                              fetchDSAQuestions();
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
                        debugPrint('Rendering DSA question ${index + 1}/${questions.length}');
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
                                  style: TextStyle(color: Colors.blue),  // Changed to blue
                                ),
                                SizedBox(height: 8),
                                
                                if (question['difficulty'] != null)  // Additional DSA-specific field
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