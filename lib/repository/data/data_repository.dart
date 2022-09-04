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

  Future<SuccessState> addAnimal(Animal animal, List<XFile> photos) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    return SuccessState.failed;
  }

  Future<void> updateAnimal(Animal animal, List<String> imageUrlsToKeep,
      List<XFile> photosToAdd) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );
  }

  Future<List<Animal>> getAnimalsByShelterID(String shelterID) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    return [];
  }

  Future<void> deleteAnimal(String animalID) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<Animal>> getFavouriteAnimals(String userID) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  Future<void> favouriteAnimal(String userID, String animalID) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> unfavouriteAnimal(String userID, String animalID) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<bool> checkIfAnimalIsFavourited(String userID, String animalID) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false;
  }
}
