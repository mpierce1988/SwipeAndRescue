import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/views/add_animals/add_animals_screen.dart';
import 'package:swipeandrescue/views/select_animal_to_modify/select_animal_to_modify_screen.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Admin'),
          LoginButton(
            color: Colors.blue,
            icon: FontAwesomeIcons.plus,
            text: 'Add Animal',
            loginMethod: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddAnimalsScreen(),
              ));
            },
          ),
          LoginButton(
            color: Colors.red,
            icon: FontAwesomeIcons.gear,
            text: 'Modify Animal',
            loginMethod: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelectAnimalToModifyScreen(),
              ));
            },
          ),
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
