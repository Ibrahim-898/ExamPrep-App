import 'package:flutter/material.dart';

class ExamRoutinePage extends StatefulWidget {
  const ExamRoutinePage({super.key});

  @override
  State<ExamRoutinePage> createState() => _ExamRoutinePageState();
}

class _ExamRoutinePageState extends State<ExamRoutinePage> {
  final List<Map<String, dynamic>> _routines = [
    {
      'subject': 'DSA',
      'topic': 'Linked Lists',
      'studyDay': 'Monday',
      'isCompleted': false,
    },
    {
      'subject': 'Java',
      'topic': 'Multithreading',
      'studyDay': 'Tuesday',
      'isCompleted': false,
    },
    {
      'subject': 'C',
      'topic': 'Pointers',
      'studyDay': 'Wednesday',
      'isCompleted': false,
    },
    {
      'subject': 'DIP',
      'topic': 'Image Filtering',
      'studyDay': 'Thursday',
      'isCompleted': false,
    },
    {
      'subject': 'DSA',
      'topic': 'Binary Trees',
      'studyDay': 'Friday',
      'isCompleted': false,
    },
  ];

  void _toggleCompletion(int index) {
    setState(() {
      _routines[index]['isCompleted'] = !_routines[index]['isCompleted'];
    });
  }

  void _addNewTask() {
    setState(() {
      _routines.add({
        'subject': 'New Subject',
        'topic': 'New Topic',
        'studyDay': 'Saturday',
        'isCompleted': false,
      });
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _routines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exam Routine'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _routines.length,
        itemBuilder: (context, index) {
          final routine = _routines[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Checkbox(
                value: routine['isCompleted'],
                onChanged: (value) => _toggleCompletion(index),
              ),
              title: Text(
                '${routine['subject']}: ${routine['topic']}',
                style: TextStyle(
                  decoration: routine['isCompleted']
                      ? TextDecoration.lineThrough
                      : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Day: ${routine['studyDay']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
