import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/repository/data/data_repository.dart';

class FirebaseDataRepository implements DataRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get list of all animals in the database
  @override
  Future<List<Animal>> getAnimals() async {
    // get all animals
    // get reference to collection location
    var ref = _db.collection('animals');
    // wait for snapshot - latest state of data - from Firebase
    var snapshot = await ref.get();
    // get data from each docoment and save to a list of data
    var data = snapshot.docs.map(
      (s) => s.data(),
    );
    // convert data into list of Animals
    var animals = data.map(
      (d) => Animal.fromJson(d),
    );

    return animals.toList();
  }

  /// Get information for one specific animal from the database
  @override
  Future<Animal> getAnimal(String animalId) async {
    // get reference to location of animal document
    var ref = _db.collection('animals').doc(animalId);
    // get current data from this document
    var snapshot = await ref.get();

    return Animal.fromJson(snapshot.data() ?? {});
  }
}
