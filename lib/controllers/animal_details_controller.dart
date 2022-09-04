import 'package:flutter/foundation.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/controller_state.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/services/data_service.dart';

class AnimalDetailsController extends ChangeNotifier {
  final DataService _dataService = DataService();
  bool isFavourited = false;
  ControllerState favouriteState = ControllerState.initialized;
  Animal? animal;

  Future<Animal?> getAnimal(String animalID) async {
    animal = await _dataService.getAnimal(animalID);

    if (animal == null) {
      return Animal();
    }

    if (animal!.animalID.isNotEmpty) {
      _checkIfFavourited(animalID);
      return animal;
    }
    return null;
  }

  _checkIfFavourited(String animalID) async {
    favouriteState = ControllerState.loading;
    notifyListeners();

    String userID = AuthenticationService().appUser.userId;
    isFavourited =
        await _dataService.checkIfAnimalIsFavourited(userID, animalID);

    favouriteState = ControllerState.completed;
    notifyListeners();
  }

  toggleFavourite() async {
    // check if animal has been retrieved yet
    if (animal == null) {
      return;
    }

    String animalID = animal!.animalID;
    favouriteState = ControllerState.loading;
    //notifyListeners();

    // get user ID
    String userID = AuthenticationService().appUser.userId;
    if (isFavourited == false) {
      // add animal to favourites
      await _dataService.favouriteAnimal(userID, animalID);
      isFavourited = true;
    } else {
      // remove animal from favourites
      await _dataService.unfavouriteAnimal(userID, animalID);
      isFavourited = false;
    }

    favouriteState = ControllerState.completed;
    notifyListeners();
  }
}
