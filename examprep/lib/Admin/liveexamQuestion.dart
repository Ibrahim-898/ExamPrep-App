
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveExamQuestionPage extends StatefulWidget {
  final String examName;

  const LiveExamQuestionPage({super.key, required this.examName});

  @override
  _LiveExamQuestionPageState createState() => _LiveExamQuestionPageState();
}

class _LiveExamQuestionPageState extends State<LiveExamQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());
  int? _selectedOptionIndex;
  int _questionNumber = 1;

  String? _error;

  void _saveQuestion() async {
    final questionText = _questionController.text.trim();
    if (questionText.isEmpty ||
        _optionControllers.any((c) => c.text.trim().isEmpty) ||
        _selectedOptionIndex == null) {
      setState(() {
        _error = 'Fill all fields and select the correct answer.';
      });
      return;
    }

    setState(() => _error = null);

    final options =
        _optionControllers.map((controller) => controller.text.trim()).toList();

    final questionData = {
      'exam_name': widget.examName,
      'question_number': _questionNumber,
      'question': questionText,
      'options': options,
      'correct_answer_index': _selectedOptionIndex,
    };

    try {
      await Supabase.instance.client.from('mcq_questions').insert(questionData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question $_questionNumber saved')),
      );

      _questionController.clear();
      for (var c in _optionControllers) {
        c.clear();
      }
      setState(() {
        _selectedOptionIndex = null;
        _questionNumber++;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save question')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Questions: ${widget.examName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Radio<int>(
                      value: index,
                      groupValue: _selectedOptionIndex,
                      onChanged: (value) =>
                          setState(() => _selectedOptionIndex = value),
                    ),
                    title: TextField(
                      controller: _optionControllers[index],
                      decoration:
                          InputDecoration(labelText: 'Option ${index + 1}'),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveQuestion,
                child: Text('Save Question $_questionNumber'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
