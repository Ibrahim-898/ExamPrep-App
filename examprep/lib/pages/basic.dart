import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BasicITQuestionsPage extends StatefulWidget {
  const BasicITQuestionsPage({super.key});

  @override
  State<BasicITQuestionsPage> createState() => _BasicITQuestionsPageState();
}

class _BasicITQuestionsPageState extends State<BasicITQuestionsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('BasicITQuestionsPage initialized');
    fetchBasicITQuestions();
  }

  Future<void> fetchBasicITQuestions() async {
    try {
      debugPrint('Attempting to fetch questions from Supabase...');
      debugPrint('Using table: short_questions');
      debugPrint('Filter: category = BasicIT');

      final response = await supabase
          .from('short_questions')
          .select()
          .eq('category', 'BasicIT');  // Changed to filter for BasicIT questions

      debugPrint('Supabase query completed');
      debugPrint('Number of BasicIT questions fetched: ${response.length}');
      
      if (response.isNotEmpty) {
        debugPrint('First BasicIT question sample: ${response.first}');
      }

      if (mounted) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
        debugPrint('State updated with ${questions.length} BasicIT questions');
      }
    } catch (error) {
      debugPrint('ERROR in fetchBasicITQuestions: $error');
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
    debugPrint('Building BasicIT widget (isLoading: $isLoading, error: $errorMessage, questions: ${questions.length})');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic IT Questions"),
        backgroundColor: Colors.purple,  // Changed to purple for BasicIT
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
                          fetchBasicITQuestions();
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
                          Text("No Basic IT questions found."),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('Retry button pressed (empty state)');
                              setState(() {
                                isLoading = true;
                              });
                              fetchBasicITQuestions();
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
                        debugPrint('Rendering BasicIT question ${index + 1}/${questions.length}');
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
                                  style: TextStyle(color: Colors.purple),  // Changed to purple
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Category: ${question['category']}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                if (question['topic'] != null)  // Additional BasicIT-specific field
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "Topic: ${question['topic']}",
                                      style: TextStyle(color: Colors.deepPurple),
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