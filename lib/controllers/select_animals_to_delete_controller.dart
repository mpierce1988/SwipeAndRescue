import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/controller_state.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/services/data_service.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class SelectAnimalsToDeleteController extends ChangeNotifier {
  ControllerState controllerState = ControllerState.initialized;
  List<Animal> animals = [];
  MultiSelectController multiSelectController = MultiSelectController();

  SelectAnimalsToDeleteController() {
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

  Future<void> deleteSelectedAnimals(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // check if any animals are selected, if not return
    if (multiSelectController.getSelectedItems().isEmpty) {
      return;
    }

    // get list of animal id's
    List<String> animalIDs = multiSelectController.getSelectedItems().map(
      (e) {
        return e.toString();
      },
    ).toList();

    // remove from database and remove from animals list
    DataService dataService = DataService();
    for (String id in animalIDs) {
      await dataService.deleteAnimal(id);
      animals.removeWhere((element) {
        return element.animalID == id;
      });
    }

    // display snackbar message
    scaffoldMessenger.showSnackBar(SnackBar(
        content: Text('You have deleted ${animalIDs.length} animals')));
    // update select animals to delete display
    notifyListeners();
  }
}
