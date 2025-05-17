import 'package:flutter/material.dart';

// Import your question pages (create these pages accordingly)
import 'dip.dart';
import 'dsa.dart';
import 'basic.dart';
import 'cprogramming.dart';
import 'systemdesign.dart';

class QuickRevision extends StatelessWidget {
  const QuickRevision({super.key});

  final List<String> topics = const [
    "DIP",
    "DSA",
    "Basic",
    "CProgramming",
    "System Design",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Revision Topics"),
        backgroundColor: const Color.fromARGB(255, 82, 181, 206),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: topics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final topic = topics[index];

            return GestureDetector(
              onTap: () {
                // Navigate to different pages based on the topic clicked
                if (topic == "DIP") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DIPQuestionsPage()),
                  );
                } else if (topic == "DSA") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DSAQuestionsPage()),
                  );
                } else if (topic == "Basic") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BasicITQuestionsPage()),
                  );
                } else if (topic == "CProgramming") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CProgrammingQuestionsPage()),
                  );
                } else if (topic == "System Design") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SystemDesignQuestionsPage()),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade400,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
