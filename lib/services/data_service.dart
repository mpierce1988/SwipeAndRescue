import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/repository/data/data_repository.dart';
import 'package:swipeandrescue/repository/data/firebase_data_repository.dart';

class DataService {
  final DataRepository _dataRepository = FirebaseDataRepository();

  /// Get list of all animals from the data repository
  Future<List<Animal>> getAnimals() async {
    return await _dataRepository.getAnimals();
  }

  // get a specific animal from the data repository
  Future<Animal> getAnimal(String animalId) async {
    return await _dataRepository.getAnimal(animalId);
  }
}
