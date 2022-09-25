import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/add_animals/add_animal_elements.dart';

class AddAnimalsScreen extends StatelessWidget {
  final AnimalFormFields animalFormFields = AddAnimalsController();
  final AddAnimalElements addAnimalElements = AddAnimalElements();

  final formKey = GlobalKey<FormState>();

  AddAnimalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: animalFormFields,
        builder: (context, widget) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Animal'),
              backgroundColor: CustomColors().primary,
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: GestureDetector(
              onTap: (() {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }),
              child: addAnimalElements.responsiveLayout(
                  context, animalFormFields.viewScrollController),
            ),
          );
        });
  }
}
