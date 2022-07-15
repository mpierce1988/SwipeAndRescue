import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticateController(),
      child: Scaffold(
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
                    loginMethod: Provider.of<AuthenticateController>(context)
                        .authenticateWithGoogle())
              ]),
        ),
      ),
    );
  }
}
