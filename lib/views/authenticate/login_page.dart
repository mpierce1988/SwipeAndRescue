import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Flexible(
              flex: 1,
              child: LoginButton(
                  color: CustomColors().primary,
                  icon: FontAwesomeIcons.google,
                  text: 'Sign in with Google',
                  loginMethod: (c) =>
                      authController.authenticateWithGoogle(context)),
            ),
            Flexible(
              flex: 1,
              child: LoginButton(
                  color: CustomColors().error,
                  icon: Icons.email,
                  text: 'Sign in with Email',
                  loginMethod: (c) => authController.switchToEmailLogin()),
            ),
            Flexible(
              flex: 1,
              child: LoginButton(
                  color: CustomColors().success,
                  icon: FontAwesomeIcons.userNinja,
                  text: 'Continue as Guest',
                  loginMethod: (c) => authController.continueAsGuest(context)),
            ),
          ]),
    );
  }
}
