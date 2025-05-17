import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionsPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

  QuestionsPage({super.key});

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await supabase.from('questions').select();
    return (response as List).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Manage Questions",
            style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchQuestions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No questions found.'));
              }

              final questions = snapshot.data!;

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.blue),
                      title: Text(q['question_text'] ?? 'No question text'),
                      subtitle: Text('Correct Answer: ${q['correct_answer']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          // TODO: Edit functionality
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
