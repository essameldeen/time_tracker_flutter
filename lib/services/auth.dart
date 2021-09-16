import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserLocal {
  UserLocal({@required this.userId});

  final String userId;
}

abstract class AuthBase {
  Stream<UserLocal> get onAuthStateChange;

  Future<UserLocal> currentUser();

  Future<UserLocal> signInAnonymously();

  Future<UserLocal> googleSignIn();

  Future<UserLocal> singnInWithFaceBook();

  Future<UserLocal> singnInWithEmailAndPassword(String email, String password);

  Future<UserLocal> creatUserWithEmailAndPassword(
      String email, String password);

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<UserLocal> get onAuthStateChange {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  UserLocal _userFromFirebase(User user) {
    if (user == null) return null;
    return UserLocal(userId: user.uid);
  }

  @override
  Future<UserLocal> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<UserLocal> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserLocal> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      if (googleSignInAuthentication.idToken != null &&
          googleSignInAuthentication.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return _userFromFirebase(userCredential.user);
      } else {
        throw PlatformException(
            code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
            message: "Missing  Google auth token");
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED BY USER",
        message: "Sign in  aborted by user",
      );
    }
  }

  @override
  Future<UserLocal> singnInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserLocal> creatUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserLocal> singnInWithFaceBook() async {
    final facebookLogin = FacebookLogin();
    final result =
        await facebookLogin.logInWithReadPermissions(['public_profile']);

    if (result.accessToken != null) {
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken.token);
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return _userFromFirebase(userCredential.user);
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED BY USER",
        message: "Sign in  aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSign = GoogleSignIn();
    await googleSign.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
