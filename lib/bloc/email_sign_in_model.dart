import 'package:time_tracker_flutter/widgets/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get PasswordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidEmailErrorText : null;
  }
  String get emailErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(email);
   return showErrorText? invalidEmailErrorText:null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
