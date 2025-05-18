// import 'package:examprep/Auth/auth_service.dart';
// import 'package:examprep/Pages/signuppage.dart';
// import 'package:flutter/material.dart';

// class Loginpage extends StatefulWidget {
//   const Loginpage({super.key});

//   @override
//   _LoginpageState createState() => _LoginpageState();
// }

// class _LoginpageState extends State<Loginpage> {
//   final authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // login
//   void login() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     // attempt login
//     try {
//       await authService.signInWithEmailPassword(email: email,password: password);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Wrong Email or Password")));
//       }
//     }
//   }

//   // UI code
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
     
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment
//                 .start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenWidth * 0.02),
//                 child: Text("Welcome to ExamPrep",
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               ),
//               Image(
//                 image: NetworkImage(
//                     'https://img.freepik.com/premium-vector/exam-concept-examination-online-test-answer-checklist-student-collage-flat-illustration-vector-banner_128772-1800.jpg?semt=ais_hybrid'),
//               ),
//               TextField(
//                 controller: _emailController, //  email controller
//                  decoration: InputDecoration(
//                   labelText: 'Phone or Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10), 
//               TextField(
//                 controller: _passwordController, 
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 obscureText: true, 
//               ),
//               SizedBox(
//                   height: 10), 
//               Text("Forget Password ?"),
//               SizedBox(height: 20), 
//               ElevatedButton(
//                 onPressed: login,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text(" Login "),
//               ),

//               SizedBox(height: 20), 
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Don't have an account?"),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Signuppage()),
//                       );
//                     },
//                     child:
//                         Text("Sign Up", style: TextStyle(color: Colors.blue)),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:examprep/Auth/auth_service.dart';
import 'package:examprep/Pages/signuppage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_isLoading) return;
    
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authService.signInWithEmailPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection timed out")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Welcome to ExamPrep",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Image.network(
                'https://img.freepik.com/premium-vector/exam-concept-examination-online-test-answer-checklist-student-collage-flat-illustration-vector-banner_128772-1800.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text("Forgot Password?"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signuppage()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}