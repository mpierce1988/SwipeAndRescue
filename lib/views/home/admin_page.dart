import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Center(
      child: Column(
        children: [
          const Text('Profile'),
          LoginButton(
            color: Colors.green,
            icon: FontAwesomeIcons.doorOpen,
            text: 'Logout',
            loginMethod: authController.signOut,
          ),
        ],
      ),
    );
  }
}
