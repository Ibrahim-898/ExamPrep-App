import 'package:examprep/Auth/auth_service.dart';
import 'package:examprep/Pages/signuppage.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // login
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // attempt login
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Wrong Email or Password")));
      }
    }
  }

  // UI code
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
     
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                child: Text("Welcome to ExamPrep",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Image(
                image: NetworkImage(
                    'https://img.freepik.com/premium-vector/exam-concept-examination-online-test-answer-checklist-student-collage-flat-illustration-vector-banner_128772-1800.jpg?semt=ais_hybrid'),
              ),
              TextField(
                controller: _emailController, //  email controller
                 decoration: InputDecoration(
                  labelText: 'Phone or Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 10), 
              TextField(
                controller: _passwordController, 
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                obscureText: true, 
              ),
              SizedBox(
                  height: 10), 
              Text("Forget Password ?"),
              SizedBox(height: 20), 
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(" Login "),
              ),

              SizedBox(height: 20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signuppage()),
                      );
                    },
                    child:
                        Text("Sign Up", style: TextStyle(color: Colors.blue)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

