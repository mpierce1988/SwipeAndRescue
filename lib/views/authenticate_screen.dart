import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/models/login_state.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: FlutterLogo(
                  size: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LoginButton(
                  color: Colors.blue,
                  icon: FontAwesomeIcons.google,
                  text: 'Sign in with Google',
                  loginMethod: _authenticateWithGoogle)
            ]),
      ),
    );
  }

  _authenticateWithGoogle(BuildContext context) async {
    debugPrint('Sign in with Google button is being pressed.');
    await AuthenticationService().authenticateWithGoogle();

    if (Provider.of<AuthenticateController>(context, listen: false)
            .loginState ==
        LoginState.authenticationFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication Failed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
