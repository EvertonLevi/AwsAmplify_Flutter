import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_amplify_example/amplifyconfiguration.dart';
import 'package:flutter_aws_amplify_example/components/camera_flow.dart';
import 'package:flutter_aws_amplify_example/services/auth_service.dart';
import 'package:flutter_aws_amplify_example/views/login_page.dart';
import 'package:flutter_aws_amplify_example/views/sign_up_page.dart';
import 'package:flutter_aws_amplify_example/views/verification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _amplify = Amplify;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _authService.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: StreamBuilder<AuthState>(
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        builder: (context) => LoginPage(
                            didProvideCredentials:
                                _authService.loginWithCredentials,
                            shouldShowSignUp: _authService.showSignUp)),
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
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void _configureAmplify() async {
    _amplify.addPlugin(AmplifyAuthCognito());
    try {
      await _amplify.configure(amplifyconfig);
      print('Amplify configurado com sucesso' + ' 🔥');
    } catch (e) {
      print('Impossível configurar Amplify ');
    }
  }
}
