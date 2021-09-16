import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/widgets/email_sign_form.dart';

class EmailSignInScreen extends StatefulWidget {
  @override
  _EmailSignInScreenState createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Sign In")),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
