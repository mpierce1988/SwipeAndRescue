import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
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

  set animalTypeID(int id) {
    switch (id) {
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

  Sex sex = Sex.unknown;
  int get sexID {
    switch (sex) {
      case Sex.female:
        return 0;
      case Sex.male:
        return 1;
      case Sex.unknown:
        return 2;
      default:
        return 2;
    }
  }

  set sexID(int id) {
    switch (id) {
      case 0:
        sex = Sex.female;
        notifyListeners();
        break;
      case 1:
        sex = Sex.male;
        notifyListeners();
        break;
      case 2:
        sex = Sex.unknown;
        notifyListeners();
        break;
      default:
        sex = Sex.unknown;
        notifyListeners();
        break;
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
