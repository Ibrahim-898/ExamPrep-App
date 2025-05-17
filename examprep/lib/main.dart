import 'package:examprep/Auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://yztwtzzchmvqsleolgoe.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHd0enpjaG12cXNsZW9sZ29lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNDc4MzEsImV4cCI6MjA2MDYyMzgzMX0.zLILLrZDoy1fgItW1Gx-adtjhp8JjsNul6Tv_29j1q8",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: AuthGate(),
       //home: AdminHome(),
      // routes: {
      //   '/' : (context) => Signuppage(),
      // },
      
    );
  }
  
  }
