import 'package:examprep/pages/homepage.dart';
import 'package:examprep/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // listen to auth state change
        stream: Supabase.instance.client.auth.onAuthStateChange,
        // build appropriate page on auth state
        builder: (context, snapShot) {
          //loading
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }

          final session = snapShot.hasData ? snapShot.data!.session : null;
          if (session != null) {
            return Homepage();
          } else {
            return Loginpage();
          }
        });
  }
}
