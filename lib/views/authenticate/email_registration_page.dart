import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class EmailRegistrationPage extends StatelessWidget {
  const EmailRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    final formKey = GlobalKey<FormState>();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Email Registration')),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Please enter your email',
                      labelText: 'Email *'),
                  controller: authController.emailRegistrationTextController,
                  validator: (value) {
                    return authController.validateEmailAddress(value);
                  },
                ),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: 'Please enter your Password',
                        labelText: 'Password *'),
                    controller:
                        authController.password1RegistrationTextController,
                    validator: (value) {
                      return authController.validatePassword(value);
                    }),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: 'Please re-enter your Password',
                        labelText: 'Password *'),
                    controller:
                        authController.password2RegistrationTextController,
                    validator: (value) {
                      if (authController
                              .password1RegistrationTextController.text !=
                          authController
                              .password2RegistrationTextController.text) {
                        return 'The password fields must match';
                      }
                      return authController.validatePassword(value);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                        color: Colors.blue,
                        icon: Icons.adaptive.arrow_back,
                        text: "Back",
                        loginMethod: authController.switchToLoginOptions),
                    LoginButton(
                        color: Colors.red,
                        icon: Icons.app_registration,
                        text: "Register",
                        loginMethod: () {
                          if (formKey.currentState!.validate()) {
                            authController.registerWithEmail();
                          }
                        }),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
