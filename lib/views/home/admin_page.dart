import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/add_animals/add_animals_screen.dart';
import 'package:swipeandrescue/views/select_animal_to_modify/select_animal_to_modify_screen.dart';
import 'package:swipeandrescue/views/select_animals_to_delete/select_animals_to_delete.dart';
import 'package:swipeandrescue/widgets/login_button.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authController =
        Provider.of<AuthenticateController>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Admin',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: CustomColors().textDisplay)),
                Text(
                    'Currently Signed In For: ${authController.appUser.shelter!.shelterName}',
                    style: TextStyle(
                        fontSize: 16, color: CustomColors().textDisplay)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LoginButton(
                        color: CustomColors().primary,
                        icon: FontAwesomeIcons.plus,
                        text: 'Add Animal',
                        loginMethod: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAnimalsScreen(),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LoginButton(
                        color: CustomColors().success,
                        icon: FontAwesomeIcons.gear,
                        text: 'Modify Animal',
                        loginMethod: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const SelectAnimalToModifyScreen(),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LoginButton(
                        color: CustomColors().error,
                        icon: FontAwesomeIcons.x,
                        text: 'Delete Animals',
                        loginMethod: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const SelectAnimalsToDeleteScreen(),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
