import 'package:flutter/material.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // This would come from your database in a real app
    final examResults = [
      {'subject': 'Mathematics', 'score': 85, 'date': '2023-05-15', 'total': 100},
      {'subject': 'Physics', 'score': 78, 'date': '2023-06-20', 'total': 100},
      {'subject': 'Chemistry', 'score': 92, 'date': '2023-07-10', 'total': 100},
      {'subject': 'Biology', 'score': 65, 'date': '2023-08-05', 'total': 100},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Overall Performance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.8, // This would be calculated from your data
                      minHeight: 20,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 10),
                    const Text('80% Average Score'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: examResults.length,
              itemBuilder: (context, index) {
                final result = examResults[index];
                final percentage = (result['score'] as int) / (result['total'] as int) * 100;
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(result['subject'] as String),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${result['date']}'),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percentage > 70 ? Colors.green : 
                            percentage > 50 ? Colors.orange : Colors.red),
                        ),
                      ],
                    ),
                    trailing: Text('${result['score']}/${result['total']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}