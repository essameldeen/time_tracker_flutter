import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/screens/lainding_screen.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingScreen(),
      ),
    );
  }
}
