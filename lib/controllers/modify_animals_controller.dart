import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/colours_enum.dart';

class ModifyAnimalsController extends AnimalFormFields {
  Animal animal;
  List<String> imageUrls = [];
  // constructor
  ModifyAnimalsController({required this.animal}) : super() {
    setFieldsFromAnimal();
  }

  setFieldsFromAnimal() {
    nameTextEditingController.text = animal.name;
    animalType = animal.animalType;
    sex = animal.sex;
    ageYears = animal.ageGroup.years;
    ageMonths = animal.ageGroup.months;
    colour = Colour.white.getColourByName(animal.colour);
    secondaryColour = Colour.white.getColourByName(animal.secondaryColour);
    behaviours = _createTextEditingControllers(animal.behaviours);
    breeds = _createTextEditingControllers(animal.breed);
    medical = _createTextEditingControllers(animal.medical);
    isNeuteured = animal.neutered;

    TextEditingController descriptionTextController = TextEditingController();
    descriptionTextController.text = animal.description;
    description = descriptionTextController;

    imageUrls = animal.images;
  }

  List<TextEditingController> _createTextEditingControllers(
      List<String> elements) {
    List<TextEditingController> results = [];

    for (String element in elements) {
      TextEditingController newTextController = TextEditingController();
      newTextController.text = element;
      results.add(newTextController);
    }

    return results;
  }
}
