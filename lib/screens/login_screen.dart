import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/bloc/sign_in_bloc.dart';
import 'package:time_tracker_flutter/screens/email_singn_screen.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/widgets/custome_raised_button.dart';
import 'package:time_tracker_flutter/widgets/platform_exception_alert_dialog.dart';

class LoginScreen extends StatelessWidget {
  final SignInBloc bloc;

  const LoginScreen({Key key, @required this.bloc}) : super(key: key);

  // how  pass l bloc in this method  ? by consumer
  static Widget create(BuildContext context) {
    final AuthBase authBase = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: authBase),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
          builder: (context, bloc, _) => LoginScreen(
                bloc: bloc,
              )),
    );
  }

  void _signInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: "Sign In Failed",
      exception: exception,
    ).show(context);
  }

  void _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      _signInError(context, e);
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {

      await bloc.googleSignIn();
    } on PlatformException catch (e) {
      _signInError(context, e);
    }
  }

  void _signInWithFaceBook(BuildContext context) async {
    try {
      await bloc.singnInWithFaceBook();
    } on PlatformException catch (e) {
      _signInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => EmailSignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 4.0,
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return buildContentBody(snapshot.data, context);
          }),
    );
  }

  Widget buildContentBody(bool isLoading, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50, child: _buildHeader(isLoading)),
          const SizedBox(
            height: 48,
          ),
          CustomRaisedButton(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/google-logo.png'),
                  Text(
                    "Sing in With Google",
                    style: TextStyle(color: Colors.black45, fontSize: 15.0),
                  ),
                  Opacity(
                      opacity: 0.0,
                      child: Image.asset('assets/images/google-logo.png')),
                ],
              ),
              onPressed: isLoading ? null : () => _signInWithGoogle(context)),
          const SizedBox(
            height: 8,
          ),
          CustomRaisedButton(
              color: Color(0xff334d92),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/facebook-logo.png'),
                  Text(
                    "Sing in With FaceBook",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  Opacity(
                      opacity: 0.0,
                      child: Image.asset('assets/images/facebook-logo.png')),
                ],
              ),
              onPressed: isLoading ? null : () => _signInWithFaceBook(context)),
          const SizedBox(
            height: 8,
          ),
          CustomRaisedButton(
            color: Colors.teal,
            child: Text(
              "Sin in With Email",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          Text(
            "or",
            textAlign: TextAlign.center,
          ),
          CustomRaisedButton(
            color: Colors.lime,
            child: Text(
              "Go anonymous",
              style: TextStyle(color: Colors.black45, fontSize: 15.0),
            ),
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
