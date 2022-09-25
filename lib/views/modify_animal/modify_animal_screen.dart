import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/modify_animals_controller.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/add_animals/add_animal_elements.dart';

class ModifyAnimalsScreen extends StatelessWidget {
  final Animal animal;
  final AddAnimalElements addAnimalElements = AddAnimalElements();
  late AnimalFormFields animalFormFields;
  ModifyAnimalsScreen({Key? key, required this.animal}) : super(key: key) {
    animalFormFields = ModifyAnimalsController(animal: animal);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: animalFormFields,
      builder: (context, widget) {
        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: CustomColors().primary,
              title: const Text('Modify Animal'),
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: addAnimalElements.responsiveLayout(
                  context, animalFormFields.viewScrollController),
            ));
      },
    );
  }
}
