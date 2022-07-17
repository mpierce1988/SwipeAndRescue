import 'package:swipeandrescue/models/animal_model.dart';

abstract class DataRepository {
  Future<List<Animal>> getAnimals() async {
    List<Animal> animals = [];

    return animals;
  }

  Future<Animal> getAnimal(String animalId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return Animal();
  }
}
