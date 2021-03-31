import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_aws_amplify_example/services/auth_credentials.dart';

enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();

  AuthCredentials _credentials;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  void loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);
      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {}
    } catch (authError) {
      print('Não foi possível fazer login - ${authError}');
    }
  }

  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};
      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (!result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        this._credentials = credentials;
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } catch (authError) {
      print('Erro no cadastro - ${authError}');
    }
  }

  void verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials.username, confirmationCode: verificationCode);
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials);
      } else {
        print('falta implementar');
      }
    } catch (authError) {
      print('Código não verificado - ${authError}');
    }
  }

  void logOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (authError) {
      print('Não foi possível fazer logout - ${authError}');
    }
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  void checkAuthStatus() async {
    try {
      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}
