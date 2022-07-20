import 'package:flutter/material.dart';
import 'package:swipeandrescue/controllers/animal_details_controller.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/animal_type.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final String animalId;
  AnimalDetailsController animalDetailsController = AnimalDetailsController();

  AnimalDetailsScreen({Key? key, required this.animalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: animalDetailsController.getAnimal(animalId),
        builder: (BuildContext context, AsyncSnapshot<Animal?> animal) {
          if (animal.connectionState == ConnectionState.waiting) {
            // show loading screen
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
              ),
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else if (animal.hasError) {
            // show error message
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text(
                    'The following error has occured. Please go back and try again. \r\n Error: ${animal.error}'),
              ),
            );
          } else if (!animal.hasData) {
            // show error message (response was empty)
            return Scaffold(
              appBar: AppBar(
                title: const Text('Empty Response'),
              ),
              body: const Center(
                child: Text(
                    'The response was empty. Please go back and try again.'),
              ),
            );
          }

          // else show animal details
          return Scaffold(
            appBar: AppBar(
              title: Text('${animal.data!.name}\'s Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text('Hello ${animal.data!.name}!'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(animal.data!.imageURL),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                      'Animal Type: ${_getAnimalTypeAsString(animal.data!.animalType)}'),
                ],
              ),
            ),
          );
        });
  }

  String _getAnimalTypeAsString(AnimalType animalType) {
    String result = '';
    switch (animalType) {
      case AnimalType.cat:
        result = 'Cat';
        break;
      case AnimalType.dog:
        result = 'Dog';
        break;
      case AnimalType.rabbit:
        result = 'Rabbit';
        break;
      case AnimalType.other:
        result = 'Other';
        break;
      default:
        result = 'Unspecified';
        break;
    }

    return result;
  }
}
