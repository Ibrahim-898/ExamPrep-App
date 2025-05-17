import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'question_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    QuestionsPage(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Questions",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MCQ Admin Panel - ${_titles[_selectedIndex]}"),
        backgroundColor: const Color.fromARGB(255, 160, 228, 120),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            backgroundColor: Colors.blueGrey[800],
            selectedIconTheme: IconThemeData(color: Colors.white),
            selectedLabelTextStyle: TextStyle(color: Colors.white),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(Icons.quiz),
                label: Text('Questions'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16.0),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

