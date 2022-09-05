import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/services/validation_service.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class EmailLoginPage extends StatelessWidget {
  EmailLoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: TextFormField(
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
              ),
              Flexible(
                flex: 4,
                child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: 'Please enter your Password',
                        labelText: 'Password *'),
                    controller: authController.passwordLoginTextController,
                    validator: (value) {
                      return ValidationService().validatePassword(value);
                    }),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                        color: CustomColors().success,
                        icon: FontAwesomeIcons.userCheck,
                        text: "Login",
                        loginMethod: (context) {
                          if (_formKey.currentState!.validate()) {
                            authController.authenticateWithEmail(context);
                          }
                        }),
                    LoginButton(
                        color: CustomColors().error,
                        icon: Icons.app_registration,
                        text: "Register",
                        loginMethod: (context) =>
                            authController.switchToEmailRegistration()),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: LoginButton(
                      color: CustomColors().primary,
                      icon: Icons.adaptive.arrow_back,
                      text: "Back",
                      loginMethod: (context) =>
                          authController.switchToLoginOptions()),
                ),
              ),
            ],
          )),
    );
  }
}
