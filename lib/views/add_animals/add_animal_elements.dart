import 'package:flutter/material.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';
import 'package:swipeandrescue/models/colours_enum.dart';
import 'package:swipeandrescue/widgets/decorated_dropdown.dart';

class AddAnimalElements {
  // Dropdowns
  Widget secondaryColourDropdown(
      BuildContext context, AddAnimalsController addAnimalController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalController.secondaryColour,
        dropDownMenuItems: [
          for (Colour value in Colour.values)
            DropdownMenuItem(
              value: value.index,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: value.color, shape: BoxShape.circle),
                    ),
                    Text(_capitalize(value.toString().split('.').last)),
                  ],
                ),
              ),
            )
        ],
        onChangedMethod: (value) =>
            addAnimalController.secondaryColour = value!);
  }

  Widget colourDropdown(
      BuildContext context, AddAnimalsController addAnimalController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalController.colour,
        dropDownMenuItems: [
          for (Colour value in Colour.values)
            DropdownMenuItem(
              value: value.index,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: value.color, shape: BoxShape.circle),
                    ),
                    Text(_capitalize(value.toString().split('.').last)),
                  ],
                ),
              ),
            )
        ],
        onChangedMethod: (value) => addAnimalController.colour = value!);
  }

  Widget ageYearsDropdown(
      BuildContext context, AddAnimalsController addAnimalController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalController.ageYears,
        dropDownMenuItems: [
          for (int i = 0; i <= 20; i++)
            DropdownMenuItem(
              value: i,
              child: Center(
                child: Text(i.toString()),
              ),
            )
        ],
        onChangedMethod: (value) => addAnimalController.ageYears = value!);
  }

  Widget ageMonthsDropdown(
      BuildContext context, AddAnimalsController addAnimalController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalController.ageMonths,
        dropDownMenuItems: [
          for (int i = 1; i <= 12; i++)
            DropdownMenuItem(
                value: i,
                child: Center(
                  child: Text(i.toString()),
                ))
        ],
        onChangedMethod: (value) => addAnimalController.ageMonths = value!);
  }

  Widget animalTypeDropdown(
      BuildContext context, AddAnimalsController addAnimalsController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalsController.animalTypeID,
        dropDownMenuItems: const [
          DropdownMenuItem(
            value: 0,
            child: Center(child: Text('Cat')),
          ),
          DropdownMenuItem(
            value: 1,
            child: Center(child: Text('Dog')),
          ),
          DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Rabbit')),
          ),
          DropdownMenuItem(
              value: 3,
              child: Center(
                child: Text('Other'),
              )),
        ],
        onChangedMethod: (value) =>
            addAnimalsController.animalTypeID = value as int);
  }

  Widget sexDropdownBox(
      BuildContext context, AddAnimalsController addAnimalController) {
    return DecoratedDropdown(
        valueToWatch: addAnimalController.sexID,
        dropDownMenuItems: const [
          DropdownMenuItem(
            value: 0,
            child: Center(
              child: Text('Female'),
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: Center(
              child: Text('Male'),
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Unknown')),
          ),
        ],
        onChangedMethod: (value) => addAnimalController.sexID = value as int);
  }

  // Helper functions
  String _capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }
}
