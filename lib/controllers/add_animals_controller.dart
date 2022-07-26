import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_type.dart';

class AddAnimalsController extends ChangeNotifier {
  AnimalType animalType = AnimalType.other;
  int get animalTypeID {
    switch (animalType) {
      case AnimalType.cat:
        return 0;
      case AnimalType.dog:
        return 1;
      case AnimalType.rabbit:
        return 2;
      default:
        return 3;
    }
  }

  TextEditingController nameTextEditingController = TextEditingController();

  setAnimalType(int index) {
    switch (index) {
      case 0:
        animalType = AnimalType.cat;
        notifyListeners();
        break;
      case 1:
        animalType = AnimalType.dog;
        notifyListeners();
        break;
      case 2:
        animalType = AnimalType.rabbit;
        notifyListeners();
        break;
      default:
        animalType = AnimalType.other;
        notifyListeners();
        break;
    }
  }

  String? validateName() {
    if (nameTextEditingController.text.isEmpty) {
      return "Please enter a name";
    }

    return null;
  }
}
