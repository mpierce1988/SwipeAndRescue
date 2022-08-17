import 'package:image_picker/image_picker.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/success_state.dart';
import 'package:swipeandrescue/repository/data/data_repository.dart';
import 'package:swipeandrescue/repository/data/firebase_data_repository.dart';

/// Provides access to the DataRepository
class DataService {
  // Part of singleton pattern
  static final DataService _instance = DataService._internal();

  late DataRepository _dataRepository;

  // Part of singleton pattern
  DataService._internal() {
    _dataRepository = FirebaseDataRepository();
  }

  // Part of Singleton pattern
  factory DataService() {
    return _instance;
  }

  /// Get list of all animals from the data repository
  Future<List<Animal>> getAnimals() async {
    return await _dataRepository.getAnimals();
  }

  // get a specific animal from the data repository
  Future<Animal> getAnimal(String animalId) async {
    return await _dataRepository.getAnimal(animalId);
  }

  // get the first image of an animal, if available. otherwise returns empty string
  Future<String> getFirstAnimalImage(String animalId) async {
    return await _dataRepository.getImageUrl(animalId);
  }

  Future<SuccessState> addAnimal(Animal animal, List<PickedFile> photos) async {
    SuccessState successState = await _dataRepository.addAnimal(animal, photos);
    return successState;
  }
}
