import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/favourite_model.dart';
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
  Future<SuccessState> addAnimal(
      Animal animal, List<XFile> photoPickedFiles) async {
    try {
      // create new document with randomly generated ID
      final newAnimalRef = _db.collection('animals').doc();
      // assign new randon id to the Animal
      animal.animalID = newAnimalRef.id;

      // upload images to google cloud, save urls to a list of Strings
      List<String> imageUrls = [];
      final storageRef = FirebaseStorage.instance.ref();

      //for(int i = 0; i < photos.length; i++)
      for (int i = 0; i < photoPickedFiles.length; i++) {
        // get reference for new file location in cloud storage
        Reference imageRef = storageRef.child(
            'images/${animal.animalID}/${photoPickedFiles[i].path.split('/').last}');

        // push file to cloud
        if (kIsWeb) {
          await imageRef.putData(await photoPickedFiles[i].readAsBytes());
        } else {
          await imageRef.putFile(File(photoPickedFiles[i].path));
        }

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

  // Gets a list of Animals for a given shelter ID
  @override
  Future<List<Animal>> getAnimalsByShelterID(String shelterID) async {
    // get documents for animals that match the shelter id
    var result = await _db
        .collection('animals')
        .where("shelterID", isEqualTo: shelterID)
        .get();

    List<Animal> animals = [];

    for (var doc in result.docs) {
      animals.add(Animal.fromJson(doc.data()));
    }

    return animals;
  }

  // Updates an animal, removes any removed images, and adds new images
  @override
  Future<void> updateAnimal(Animal animal, List<String> imageUrlsToKeep,
      List<XFile> photosToAdd) async {
    var storageRef =
        FirebaseStorage.instance.ref().child('images/${animal.animalID}');

    // remove images that are not in the imagesUrlsToKeep list
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      for (String imageUrl in imageUrlsToKeep) {
        if (imageUrl.split('%2F').last.split('?alt').first == item.name) {
          // item in cloud storage matches item to keep
          // do nothing
          debugPrint(
              'Item ${item.name} matches a requested images to keep. Doing nothing...');
        } else {
          // item in cloud storage does not match item to keep
          // delete item
          debugPrint(
              'Item ${item.name} does not match any requested images to keep. Deleting it...');
          item.delete();
        }
      }
    }
    // add the new XFile images
    for (int i = 0; i < photosToAdd.length; i++) {
      // get reference for new file location in cloud storage
      Reference imageRef =
          storageRef.child('${photosToAdd[i].path.split('/').last}.jpg');

      // push file to cloud
      if (kIsWeb) {
        await imageRef.putData(await photosToAdd[i].readAsBytes());
      } else {
        await imageRef.putFile(File(photosToAdd[i].path));
      }
    }
    // add new urls to animal
    // get new list of images in cloud storage
    storageRef =
        FirebaseStorage.instance.ref().child('images/${animal.animalID}');
    final finalListResult = await storageRef.listAll();
    List<String> finalImageUrls = [];
    for (Reference item in finalListResult.items) {
      String url = await item.getDownloadURL().catchError((e) {
        return '';
      });
      if (url != '') {
        finalImageUrls.add(url);
      }
    }
    animal.images = finalImageUrls;
    // update animal document
    // get reference to the document
    final docRef = _db.collection('animals').doc(animal.animalID);
    docRef.set(animal.toJson());
  }

  // delete the animal document and any images for a given animal id
  @override
  Future<void> deleteAnimal(String animalID) async {
    // check if animal document exists
    var reference = _db.collection('animals').doc(animalID);
    var document = await reference.get();
    if (document.exists) {
      // delete document
      await reference.delete();
    }

    // delete every image for this animal from google storage
    var storageRef = FirebaseStorage.instance.ref().child('images/$animalID');
    var listResults = await storageRef.listAll();

    _deleteAllFiles(listResults);
  }

  _deleteAllFiles(ListResult listResults) async {
    if (listResults.items.isNotEmpty) {
      // delete all items
      for (var item in listResults.items) {
        await item.delete();
      }
    }

    if (listResults.prefixes.isNotEmpty) {
      for (var prefix in listResults.prefixes) {
        _deleteAllFiles(await prefix.listAll());
      }
    }
  }

  // adds the specified animal to the user's favourites list
  @override
  Future<void> favouriteAnimal(String userID, String animalID) async {
    // check if a favourite already exists. if so, return out of method

    if (await checkIfAnimalIsFavourited(userID, animalID)) {
      // a favourites entry already exists
      return;
    }

    // create reference to favourites collection
    var storageRef = _db.collection('favourites');
    // create a new document
    var favouriteDocument = storageRef.doc();
    // add the userID and animalID to an instance of Favourite
    Favourite favourite = Favourite(userID: userID, animalID: animalID);

    // add to document and push to database
    favouriteDocument.set(favourite.toJson());
  }

  @override
  Future<List<Animal>> getFavouriteAnimals(String userID) async {
    // get list of favourite documents matching this userID
    var favouriteDocs = await _db
        .collection('favourites')
        .where('userID', isEqualTo: userID)
        .get();

    // check if list of docs is empty
    if (favouriteDocs.docs.isEmpty) {
      return [];
    }

    // loop through favourites documents, retrieve the information for
    // each animal
    List<Animal> results = [];
    for (var favdoc in favouriteDocs.docs) {
      Favourite favourite = Favourite.fromJson(favdoc.data());
      Animal animalToAdd = await getAnimal(favourite.animalID);
      results.add(animalToAdd);
    }

    return results;
  }

  @override
  Future<bool> checkIfAnimalIsFavourited(String userID, String animalID) async {
    var potentialFavourite = await _db
        .collection('favourites')
        .where('userID', isEqualTo: userID)
        .where('animalID', isEqualTo: animalID)
        .get();
    if (potentialFavourite.docs.isEmpty) {
      return false;
    }

    return true;
  }
}
