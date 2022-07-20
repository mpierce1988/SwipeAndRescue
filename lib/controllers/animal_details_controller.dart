import 'package:flutter/foundation.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/services/data_service.dart';

class AnimalDetailsController extends ChangeNotifier {
  final DataService _dataService = DataService();

  Future<Animal?> getAnimal(String animalId) async {
    Animal animal = await _dataService.getAnimal(animalId);

    if (animal.animalID.isNotEmpty) {
      return animal;
    }
    return null;
  }
}
