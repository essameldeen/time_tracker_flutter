import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/screens/home_page.dart';
import 'package:time_tracker_flutter/screens/login_screen.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth= Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<UserLocal>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          UserLocal user = snapshot.data;
          if (user == null) {
            return LoginScreen.create(context);
          } else {
            return HomeScreen();
          }
        } else {
          return LoginScreen.create(context);
        }
      },
    );
  }
}
