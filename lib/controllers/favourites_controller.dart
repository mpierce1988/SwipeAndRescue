import 'package:flutter/cupertino.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/services/data_service.dart';

import '../models/controller_state.dart';

class FavouritesController extends ChangeNotifier {
  String userID;
  List<Animal> animals = [];
  ControllerState controllerState = ControllerState.initialized;
  DataService dataService = DataService();

  FavouritesController({required this.userID}) {
    getFavouriteAnimalsForUser();
  }

  Future<void> getFavouriteAnimalsForUser() async {
    // switch to loading state
    controllerState = ControllerState.loading;
    notifyListeners();

    // load favourited animals from data service
    List<Animal> results = await dataService.getFavouriteAnimals(userID);
    animals = results;

    // change controller state to complete
    controllerState = ControllerState.completed;
    notifyListeners();
  }
}
