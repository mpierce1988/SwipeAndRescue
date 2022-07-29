import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/animal_type.dart';
import 'package:swipeandrescue/models/colours_enum.dart';

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

  int _ageYears = 0;
  int get ageYears => _ageYears;
  set ageYears(int years) {
    if (years < 0) {
      years = 0;
    } else if (years > 20) {
      years = 20;
    }

    _ageYears = years;
    notifyListeners();
  }

  int _ageMonths = 1;
  int get ageMonths => _ageMonths;
  set ageMonths(int months) {
    if (months < 1) {
      months = 1;
    } else if (months > 12) {
      months = 12;
    }

    _ageMonths = months;
    notifyListeners();
  }

  Colour _colour = Colour.white;
  int get colour => _colour.index;
  set colour(int id) {
    if (id < 0 || id > Colour.values.length - 1) {
      _colour = Colour.white;
      notifyListeners();
      return;
    }

    _colour = Colour.values[id];
    notifyListeners();
  }

  Colour _secondaryColour = Colour.white;
  int get secondaryColour => _secondaryColour.index;
  set secondaryColour(int id) {
    if (id < 0 || id > Colour.values.length - 1) {
      _secondaryColour = Colour.white;
      notifyListeners();
      return;
    }

    _secondaryColour = Colour.values[id];
    notifyListeners();
  }

  List<TextEditingController> _behaviours = [];
  List<TextEditingController> get behaviours => _behaviours;
  set behaviours(List<TextEditingController> behaviours) {
    _behaviours = behaviours;
    notifyListeners();
  }

  List<TextEditingController> _breeds = [];
  List<TextEditingController> get breeds => _breeds;
  set breeds(List<TextEditingController> breeds) {
    _breeds = breeds;
    notifyListeners();
  }

  List<TextEditingController> _medical = [];
  List<TextEditingController> get medical => _medical;
  set medical(List<TextEditingController> medical) {
    _medical = medical;
    notifyListeners();
  }

  bool _isNeuteured = false;
  bool get isNeuteured => _isNeuteured;
  set isNeuteured(bool value) {
    _isNeuteured = value;
    notifyListeners();
  }

  TextEditingController _description = TextEditingController();
  TextEditingController get description => _description;
  set description(TextEditingController controller) {
    _description = controller;
    notifyListeners();
  }

  List<File> _images = [];
  List<File> get images => _images;
  set images(List<File> images) {
    _images = images;
    notifyListeners();
  }

  addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  removeImage(File image) {
    if (_images.contains(image)) {
      _images.remove(image);
      notifyListeners();
    }
  }

  TextEditingController nameTextEditingController = TextEditingController();

  String? validateName() {
    if (nameTextEditingController.text.isEmpty) {
      return "Please enter a name";
    }

    return null;
  }
}
