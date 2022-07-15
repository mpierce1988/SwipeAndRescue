import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Flexible(
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
                  loginMethod: (c) =>
                      authController.authenticateWithGoogle(context)),
              LoginButton(
                  color: Colors.red,
                  icon: Icons.email,
                  text: 'Sign in with Email',
                  loginMethod: (c) => authController.switchToEmailLogin()),
              LoginButton(
                  color: Colors.green,
                  icon: FontAwesomeIcons.userNinja,
                  text: 'Continue as Guest',
                  loginMethod: (c) => authController.continueAsGuest(context)),
            ]),
      ),
    );
  }
}
