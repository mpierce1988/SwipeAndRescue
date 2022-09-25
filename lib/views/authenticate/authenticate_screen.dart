import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/models/login_state.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/authenticate/email_login_page.dart';
import 'package:swipeandrescue/views/authenticate/email_registration_page.dart';
import 'package:swipeandrescue/views/authenticate/login_page.dart';
import 'package:swipeandrescue/views/home/home_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    if (authController.loginState == LoginState.authenticationSuccessful) {
      return const HomeScreen();
    }

    // else, its the options menu
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: CustomColors().primary,
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        controller: authController.pageController,
        children: [
          const LoginPage(),
          EmailLoginPage(),
          const EmailRegistrationPage(),
        ],
      ),
    );
  }
}
