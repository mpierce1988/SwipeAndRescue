import 'package:flutter/cupertino.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/services/data_service.dart';

class BrowseAnimalsController extends ChangeNotifier {
  final DataService _dataService = DataService();

  /// Gets a list of animals from the data service
  Future<List<Animal>> getAnimals() async {
    return await _dataService.getAnimals();
  }

  /// Gets a specific animal from the data service
  Future<Animal> getAnimal(String animalID) async {
    return await _dataService.getAnimal(animalID);
  }
}
