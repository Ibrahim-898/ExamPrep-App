import 'package:flutter/material.dart';
import 'live_exam_form.dart'; // Import the live exam form page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Admin 👋", style: Theme.of(context).textTheme.headlineSmall),
        _buildLiveExamSetup(context),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Card(
      elevation: 4,
      child: Container(
        width: 250,
        height: 120,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            SizedBox(height: 10),
            Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Add a clickable container to navigate to Live Exam setup
  Widget _buildLiveExamSetup(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to live exam setup form
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveExamFormPage()),
        );
      },
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_alarm, color: Colors.blue, size: 40),
              SizedBox(height: 10),
              Text(
                "Set Live Exam",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text("Click here to set up the exam for your students"),
            ],
          ),
        ),
      ),
    );
  }
}
