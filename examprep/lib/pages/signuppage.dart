// import 'package:examprep/Auth/auth_service.dart';
// import 'package:examprep/pages/homepage.dart';
// import 'package:flutter/material.dart';

// class Signuppage extends StatefulWidget {
//   const Signuppage({super.key});

//   @override
//   _SignuppageState createState() => _SignuppageState();
// }

// class _SignuppageState extends State<Signuppage> {
//   final authService = AuthService();
//   // Text controllers for form inputs
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailPhoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailPhoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void signup() async {
//     final email = _emailPhoneController.text;
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;
//     // check for password match
//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("PassWord Don't Match")));
//       return;
//     }
//     // attempt sign up
//     try {
//       await authService.signUpWithEmailPassword(email, password);
//       Navigator.pop(context);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Error")));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         // Makes content scrollable on smaller screens
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(height: 50),
//               Text(
//                 "Register for Best preparation with ExamPrep",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 30),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: "Enter Your Full Name",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: _emailPhoneController,
//                 decoration: InputDecoration(
//                   labelText: "Enter Your Phone or Email",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Enter Password",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Confirm Password",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: signup,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 child: Text("Register / Sign Up"),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Text("Already have an account? "),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Homepage()),
//                       );
//                     },
//                     child: Text(
//                       "HomePage",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:examprep/Auth/auth_service.dart';
import 'package:examprep/pages/homepage.dart';
import 'package:examprep/pages/loginpage.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  _SignuppageState createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final authService = AuthService();
  // Text controllers for form inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _departmentController.dispose();
    _yearController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final department = _departmentController.text.trim();
    final yearText = _yearController.text.trim();

    // Validate all fields
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match")),
      );
      return;
    }

    if (name.isEmpty || 
        email.isEmpty || 
        mobile.isEmpty || 
        department.isEmpty || 
        yearText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Validate year is a number
    int? year;
    try {
      year = int.parse(yearText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Year must be a valid number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authService.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
        mobile: mobile,
        dept: department,
        year: year, // Now passing as int
      );
      
      if (mounted) {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
      );
      
      // Optional: Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Please login")),
      );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${e.toString()}")),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Register for Best preparation with ExamPrep",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register / Sign Up"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                  );
                },
                child: const Text(
                  "HomePage",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}