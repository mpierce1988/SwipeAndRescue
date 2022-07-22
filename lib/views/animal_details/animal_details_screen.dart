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
          // local variables to make null checking easier
          String name = animal.data!.name != '' ? animal.data!.name : 'Someone';
          AnimalType animalType = animal.data!.animalType;
          List<String> behaviours = animal.data!.behaviours.isNotEmpty
              ? animal.data!.behaviours
              : ['Unknown'];
          List<String> breed =
              animal.data!.breed.isNotEmpty ? animal.data!.breed : ['Unknown'];
          String colour =
              animal.data!.colour != '' ? animal.data!.colour : 'Unknown';
          String secondaryColour = animal.data!.secondaryColour != ''
              ? animal.data!.secondaryColour
              : 'Unknown';
          String description = animal.data!.description != ''
              ? animal.data!.description
              : 'None available';
          List<String> medical = animal.data!.medical.isNotEmpty
              ? animal.data!.medical
              : ['Not Available'];
          bool neutered = animal.data!.neutered;
          Sex sex = animal.data!.sex;
          String imageURL = animal.data!.imageURL;
          AgeGroup ageGroup = animal.data!.ageGroup;

          List<bool> openPanels = [false, false, false, false, false, false];

          return Scaffold(
            appBar: AppBar(
              title: Text('$name\'s Profile'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text('Hello $name!'),
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
                    Text('Colour: $colour'),
                    Text(
                        'Age: ${ageGroup.years} years, ${ageGroup.months} months'),
                    AnimalInfoExpansionList(
                        description: description,
                        behaviour: behaviours,
                        breed: breed,
                        medical: medical),
                  ],
                ),
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

class AnimalInfoExpansionList extends StatefulWidget {
  String description;
  List<String> behaviour;
  List<String> breed;
  List<String> medical;

  AnimalInfoExpansionList(
      {Key? key,
      required this.description,
      required this.behaviour,
      required this.breed,
      required this.medical})
      : super(key: key);

  @override
  State<AnimalInfoExpansionList> createState() =>
      _AnimalInfoExpansionListState();
}

class _AnimalInfoExpansionListState extends State<AnimalInfoExpansionList> {
  final List<bool> _isOpen = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isOpen[panelIndex] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: _isOpen[0],
          headerBuilder: (BuildContext context, bool state) {
            return const Text('Description');
          },
          body: Text(widget.description),
        ),
        ExpansionPanel(
          isExpanded: _isOpen[1],
          headerBuilder: (BuildContext context, bool state) {
            return const Text('Behaviours');
          },
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.behaviour.length,
              itemBuilder: ((context, index) {
                return Text(widget.behaviour[index]);
              })),
        ),
        ExpansionPanel(
          isExpanded: _isOpen[2],
          headerBuilder: (BuildContext context, bool state) {
            return const Text('Breed');
          },
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.behaviour.length,
              itemBuilder: ((context, index) {
                return Text(widget.breed[index]);
              })),
        ),
        ExpansionPanel(
          isExpanded: _isOpen[3],
          headerBuilder: (BuildContext context, bool state) {
            return const Text('Medical');
          },
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.behaviour.length,
              itemBuilder: ((context, index) {
                return Text(widget.medical[index]);
              })),
        ),
      ],
    );
  }
}
