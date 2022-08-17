import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/success_state.dart';
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

  @override
  Future<String> getImageUrl(String animalId) async {
    final storage = FirebaseStorage.instance;
    final storageReference = storage.ref().child('images/$animalId/');

    dynamic listResult;
    try {
      listResult = await storageReference.listAll();
    } catch (e) {
      debugPrint(e.toString());
    }

    // return empty string if no images
    if (listResult == null || listResult.items.isEmpty) {
      return '';
    }

    // else, return the first image
    debugPrint(await listResult.items[0].getDownloadURL());
    return listResult.items[0].getDownloadURL();
  }

  @override
  Future<SuccessState> addAnimal(Animal animal, List<String> photoUrls) async {
    try {
      // create new document with randomly generated ID
      final newAnimalRef = _db.collection('animals').doc();
      // assign new randon id to the Animal
      animal.animalID = newAnimalRef.id;

      // upload images to google cloud, save urls to a list of Strings
      List<String> imageUrls = [];
      final storageRef = FirebaseStorage.instance.ref();

      // create a list of Uri pointing to internal photo location
      List<Uri> photos = [];

      for (String url in photoUrls) {
        photos.add(Uri.parse(url));
      }

      for (var photo in photos) {
        // get reference for new file location in cloud storage
        Reference imageRef = storageRef
            .child('images/${animal.animalID}/${photo.pathSegments.last}');

        // create File object from photo uri
        File file = File.fromUri(photo);

        // push file to cloud
        await imageRef.putFile(file);

        // add url to list of urls
        imageUrls.add(await imageRef.getDownloadURL());
      }
      // add list of image urls to animal
      animal.images = imageUrls;
      // set the animal information

      bool updateSuccessful = true;

      await newAnimalRef.set(animal.toJson()).catchError((error) {
        debugPrint(error.toString());
        updateSuccessful = false;
      });

      // success check
      if (!updateSuccessful) {
        // delete attempted record
        await _deleteAnimalFromFirebase(animal);

        return SuccessState.failed;
      }

      // otherwise, it was successful
      return SuccessState.succeeded;
    } catch (e) {
      debugPrint(e.toString());
      _deleteAnimalFromFirebase(animal);
      return SuccessState.failed;
    }
  }

  Future<void> _deleteAnimalFromFirebase(Animal animal) async {
    await _db.collection('animals').doc(animal.animalID).delete();
    // get list of any files added for this animal
    final storageRef =
        FirebaseStorage.instance.ref().child('images/${animal.animalID}');
    final listResult = await storageRef.listAll();
    // delete any images that were uploaded
    for (var item in listResult.items) {
      await item.delete();
    }
  }
}
