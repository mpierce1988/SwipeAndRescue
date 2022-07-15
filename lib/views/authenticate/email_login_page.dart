import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/services/validation_service.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class EmailLoginPage extends StatelessWidget {
  EmailLoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Email Login2')),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Please enter your email',
                      labelText: 'Email *'),
                  controller: authController.emailLoginTextController,
                  validator: (value) {
                    return ValidationService().validateEmailAddress(value);
                  },
                ),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: 'Please enter your Password',
                        labelText: 'Password *'),
                    controller: authController.passwordLoginTextController,
                    validator: (value) {
                      return ValidationService().validatePassword(value);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                        color: Colors.green,
                        icon: FontAwesomeIcons.userCheck,
                        text: "Login",
                        loginMethod: (context) {
                          if (_formKey.currentState!.validate()) {
                            authController.authenticateWithEmail(context);
                          }
                        }),
                    LoginButton(
                        color: Colors.red,
                        icon: Icons.app_registration,
                        text: "Register",
                        loginMethod: (context) =>
                            authController.switchToEmailRegistration()),
                  ],
                ),
                LoginButton(
                    color: Colors.blue,
                    icon: Icons.adaptive.arrow_back,
                    text: "Back",
                    loginMethod: (context) =>
                        authController.switchToLoginOptions()),
              ],
            )),
      ),
    );
  }
}
