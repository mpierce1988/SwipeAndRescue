import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.asset('assets/logo.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello ${authController.appUser.displayName}!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const Text('Thank you for using Swipe and Rescue'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current email: ${authController.appUser.email}',
                    style: const TextStyle(fontSize: 16)),
                if (authController.appUser.shelter != null &&
                    authController.appUser.shelter!.shelterName != '')
                  Text(
                      'You work for ${authController.appUser.shelter!.shelterName}!',
                      style: const TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: LoginButton(
                    color: CustomColors().success,
                    icon: FontAwesomeIcons.doorOpen,
                    text: 'Logout',
                    loginMethod: authController.signOut,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
