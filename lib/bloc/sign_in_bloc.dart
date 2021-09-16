import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<UserLocal> _signIn(Future<UserLocal> Function() siginMethod) async {
    try {
      _setIsLoading(true);
      return await siginMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<UserLocal> signInAnonymously() async =>
      _signIn(auth.signInAnonymously);

  Future<UserLocal> googleSignIn() async => _signIn(auth.googleSignIn);

  Future<UserLocal> singnInWithFaceBook() async =>
      _signIn(auth.singnInWithFaceBook);
}
