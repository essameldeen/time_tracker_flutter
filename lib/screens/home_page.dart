import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/services/auth.dart';

import 'package:time_tracker_flutter/widgets/platform_alert_dialog.dart';

class HomeScreen extends StatelessWidget {


  void _sinOut(BuildContext context) async {
    final authBase = Provider.of<AuthBase>(context,listen: false);


    try {
      await authBase.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    final sinoutOrnot = await PlatformAlertDialog(
      title: "Log out",
      content: "Are you sure you want logout?",
      cancelActionText: "Cancel",
      defaultActionText: "Logout",
    ).show(context);
    if (sinoutOrnot) _sinOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                "Log out",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ))
        ],
      ),
    );
  }
}
