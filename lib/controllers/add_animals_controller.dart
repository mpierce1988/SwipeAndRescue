import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/models/colours_enum.dart';
import 'package:swipeandrescue/models/success_state.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/services/data_service.dart';

class AddAnimalsController extends AnimalFormFields {
  String? validateName() {
    if (nameTextEditingController.text.isEmpty) {
      return "Please enter a name";
    }

    return null;
  }

  /// Submits the animal and images to the database, and returns a success state
  /// as a response
  Future<SuccessState> submitAnimal(BuildContext context) async {
    // create animal model
    Animal animal = Animal();
    // set the fields

    List<String> newBehaviours = [];
    for (TextEditingController behaveController in behaviours) {
      if (behaveController.text != '') {
        newBehaviours.add(behaveController.text);
      }
    }

    List<String> newBreeds = [];
    for (TextEditingController breedController in breeds) {
      if (breedController.text != '') {
        newBreeds.add(breedController.text);
      }
    }

    List<String> newMedical = [];
    for (TextEditingController medicalController in medical) {
      if (medicalController.text != '') {
        newMedical.add(medicalController.text);
      }
    }

    animal.name = nameTextEditingController.text;
    animal.animalType = animalType;
    animal.sex = sex;
    animal.ageGroup = AgeGroup(years: ageYears, months: ageMonths);
    animal.colour = Colour.values[colour].name();
    animal.secondaryColour = Colour.values[secondaryColour].name();
    animal.behaviours = newBehaviours;
    animal.breed = newBreeds;
    animal.medical = newMedical;
    animal.description = description.text;
    animal.neutered = isNeuteured;

    AppUser currentUser = AuthenticationService().appUser;
    debugPrint(
        "Current user is ${currentUser.displayName} ${currentUser.userId}at Shelter ${currentUser.shelter!.shelterName} at ${currentUser.shelter!.shelterId}");
    animal.shelterID = currentUser.shelter!.shelterId;
    animal.shelterName == currentUser.shelter!.shelterName;
    animal.addedByUserID = currentUser.userId;

    var error;
    // submit as new animal
    DataService dataService = DataService();
    SuccessState successState =
        await dataService.addAnimal(animal, images).catchError((e) {
      return SuccessState.failed;
    });

    return successState;
  }
}
