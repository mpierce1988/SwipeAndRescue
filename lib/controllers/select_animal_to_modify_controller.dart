import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/controller_state.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/services/data_service.dart';

class SelectAnimalToModifyController extends ChangeNotifier {
  ControllerState controllerState = ControllerState.initialized;
  List<Animal> animals = [];

  SelectAnimalToModifyController() {
    getAnimalsForCurrentUser();
  }

  // gets a list of animals for the current shelter from the database
  getAnimalsForCurrentUser() async {
    AuthenticationService authService = AuthenticationService();
    // verify current user has a shelter ID
    if (authService.appUser.shelter == null ||
        authService.appUser.shelter!.shelterId == '') {
      // no shelter ID for this user, display error
      controllerState = ControllerState.hasError;
      notifyListeners();
      return;
    }

    // begin loading state
    controllerState = ControllerState.loading;
    notifyListeners();

    // get current shelter ID for user
    String shelterID = authService.appUser.shelter!.shelterId;

    // get results, save to animals list
    animals = await DataService().getAnimalsByShelterID(shelterID);

    // change state to complete
    controllerState = ControllerState.completed;
    notifyListeners();
  }
}
