
// import 'dart:async';
// import 'package:examprep/pages/performancepage.dart';
// import 'package:examprep/pages/profilepage.dart';
// import 'package:flutter/material.dart';
// import 'package:examprep/Auth/auth_service.dart';
// import 'package:examprep/pages/QuickRevision.dart';
// import 'package:examprep/pages/Question_bank.dart';
// import 'package:examprep/pages/Routine.dart';
// import 'package:examprep/pages/live_exam_page.dart';


// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   _HomepageState createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   final authService = AuthService();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   final List<String> motivationalMessages = [
//     "Stay focused and keep pushing! Your hard work will pay off.",
//     "Every day is a new opportunity to learn something new.",
//     "Believe in yourself and all that you are.",
//     "Success is the sum of small efforts repeated day in and day out.",
//     "Don't watch the clock; do what it does. Keep going.",
//     "Your limitation—it's only your imagination.",
//   ];

//   final List<Color> cardColors = [
//     const Color.fromARGB(255, 78, 114, 144),
//     const Color.fromARGB(255, 59, 74, 60),
//     const Color.fromARGB(255, 107, 95, 76),
//     const Color.fromARGB(255, 100, 69, 106),
//     Colors.red.shade300,
//     Colors.teal.shade300,
//   ];

//   late final PageController _pageController = PageController();
//   int _currentPage = 0;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
//       if (_currentPage < motivationalMessages.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   void logout() async {
//     await authService.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final labels = ["Question Bank", "Routine", "Previous Exam", "Quick Revision"];
//     final icons = [
//       Icons.question_answer,
//       Icons.schedule,
//       Icons.hourglass_bottom,
//       Icons.read_more,
//     ];

//     return Scaffold(
//       key: _scaffoldKey, // Add key here
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 82, 181, 206),
//         leading: IconButton(
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer(); // Use the key to open drawer
//           }, 
//           icon: const Icon(Icons.menu)
//         ),
//         centerTitle: true,
//         title: const Text("ExamPrep"),
//         actions: [
//           IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
//         ],
//       ),
//       drawer: buildDrawer(context),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 100,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: motivationalMessages.length,
//                 itemBuilder: (context, index) {
//                   final color = cardColors[index % cardColors.length];
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.lightbulb, color: Colors.white, size: 32),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             motivationalMessages[index],
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: List.generate(4, (index) {
//                   return buildGridItem(context, icons[index], labels[index], cardColors[index]);
//                 }),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => ExamScreen()));
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 decoration: BoxDecoration(
//                   color: cardColors[3],
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Live Exam',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 82, 181, 206),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 40, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'User Name',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text(
//                   'user@example.com',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.assessment),
//             title: const Text('Performance'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, MaterialPageRoute(builder: (_) => PerformancePage()));
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               // Add settings navigation here
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildGridItem(BuildContext context, IconData icon, String label, Color color) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           if (label == "Question Bank") {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionBank()));
//           } else if (label == "Routine") {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => Routine()));
//           } else if (label == "Quick Revision") {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => QuickRevision()));
//           }
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 6,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: Colors.white),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:examprep/pages/performancepage.dart';
import 'package:examprep/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:examprep/Auth/auth_service.dart';
import 'package:examprep/pages/QuickRevision.dart';
import 'package:examprep/pages/Question_bank.dart';
import 'package:examprep/pages/Routine.dart';
import 'package:examprep/pages/live_exam_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? _userProfile;
  bool _isProfileLoading = true;

  final List<String> motivationalMessages = [
    "Stay focused and keep pushing! Your hard work will pay off.",
    "Every day is a new opportunity to learn something new.",
    "Believe in yourself and all that you are.",
    "Success is the sum of small efforts repeated day in and day out.",
    "Don't watch the clock; do what it does. Keep going.",
    "Your limitation—it's only your imagination.",
  ];

  final List<Color> cardColors = [
    const Color.fromARGB(255, 78, 114, 144),
    const Color.fromARGB(255, 59, 74, 60),
    const Color.fromARGB(255, 107, 95, 76),
    const Color.fromARGB(255, 100, 69, 106),
    Colors.red.shade300,
    Colors.teal.shade300,
  ];

  late final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < motivationalMessages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isProfileLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProfileLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
        );
      }
    }
  }

  void logout() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final labels = ["Question Bank", "Routine", "Previous Exam", "Quick Revision"];
    final icons = [
      Icons.question_answer,
      Icons.schedule,
      Icons.hourglass_bottom,
      Icons.read_more,
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 181, 206),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        centerTitle: true,
        title: const Text("ExamPrep"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: PageView.builder(
                controller: _pageController,
                itemCount: motivationalMessages.length,
                itemBuilder: (context, index) {
                  final color = cardColors[index % cardColors.length];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            motivationalMessages[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(4, (index) {
                  return _buildGridItem(
                    context, 
                    icons[index], 
                    labels[index], 
                    cardColors[index]
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const ExamScreen()),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: cardColors[3],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Live Exam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 82, 181, 206),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person, 
                    size: 40, 
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isProfileLoading 
                    ? 'Loading...' 
                    : _userProfile?['name'] ?? 'No name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isProfileLoading
                    ? 'loading...'
                    : _userProfile?['email'] ?? 'No email',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Performance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const PerformancePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add settings navigation here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String label, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (label == "Question Bank") {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const QuestionBank()),
            );
          } else if (label == "Routine") {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const ExamRoutinePage()),
            );
          } else if (label == "Quick Revision") {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const QuickRevision()),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}