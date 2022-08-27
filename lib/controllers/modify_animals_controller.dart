import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/colours_enum.dart';
import 'package:swipeandrescue/models/success_state.dart';
import 'package:swipeandrescue/services/data_service.dart';

class ModifyAnimalsController extends AnimalFormFields {
  Animal animal;

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
    imagesFromWebUrls = animal.images;
    animalId = animal.animalID;

    TextEditingController descriptionTextController = TextEditingController();
    descriptionTextController.text = animal.description;
    description = descriptionTextController;
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

  @override
  Future<SuccessState> submitAnimal() async {
    // create animal
    Animal animal = createAnimalFromFormFields();

    SuccessState result = SuccessState.succeeded;

    // update animal
    await DataService()
        .updateAnimal(animal, imagesFromWebUrls, imagesFromPicker)
        .onError((error, stackTrace) {
      debugPrint('The following error has occured: ${error.toString()}');
      result = SuccessState.failed;
    });

    return result;
  }
}
