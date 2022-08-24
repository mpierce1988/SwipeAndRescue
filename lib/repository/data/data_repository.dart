import 'package:image_picker/image_picker.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/success_state.dart';

abstract class DataRepository {
  Future<List<Animal>> getAnimals() async {
    List<Animal> animals = [];

    return animals;
  }

  Future<Animal> getAnimal(String animalId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Animal();
  }

  Future<String> getImageUrl(String animalId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return '';
  }

  Future<SuccessState> addAnimal(Animal animal, List<PickedFile> photos) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    return SuccessState.failed;
  }

  Future<List<Animal>> getAnimalsByShelterID(String shelterID) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    return [];
  }
}
