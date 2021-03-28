import 'package:flutter/material.dart';
import 'package:flutter_aws_amplify_example/components/camera_flow.dart';
import 'package:flutter_aws_amplify_example/services/auth_service.dart';
import 'package:flutter_aws_amplify_example/views/login_page.dart';
import 'package:flutter_aws_amplify_example/views/sign_up_page.dart';
import 'package:flutter_aws_amplify_example/views/verification_page.dart';

// PAREI EM: Se você executar o aplicativo desta vez, note que será capaz de alternar entre o LoginPage e o SignUpPage.

void main() {
  runApp(MyApp());
}

// 1
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // 2
      home: StreamBuilder<AuthState>(
          // 2
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4
                  // Show Login Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        builder: (context) => LoginPage(
                            didProvideCredentials:
                                _authService.loginWithCredentials,
                            shouldShowSignUp: _authService.showSignUp)),

                  // 5
                  // Show Sign Up Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        builder: (context) => SignUpPage(
                            didProvideCredentials:
                                _authService.signUpWithCredentials,
                            shouldShowLogin: _authService.showLogin)),

                  if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        builder: (context) =>
                            CameraFlow(shouldLogOut: _authService.logOut)),

                  if (snapshot.data.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        builder: (context) => VerificationPage(
                              didProvideVerificationCode:
                                  _authService.verifyCode,
                            ))
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
