import 'package:flutter/material.dart';
import 'package:swipeandrescue/controllers/animal_details_controller.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/animal_type.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/utilities.dart';
import 'package:swipeandrescue/views/animal_details/animal_pictures_carousel.dart';
import 'package:swipeandrescue/widgets/favourite_button.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final String animalId;
  final AnimalDetailsController animalDetailsController =
      AnimalDetailsController();

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
          //bool neutered = animal.data!.neutered;
          Sex sex = animal.data!.sex;
          //String imageURL = animal.data!.imageURL;
          AgeGroup ageGroup = animal.data!.ageGroup;
          List<String> images = animal.data!.images;

          return Scaffold(
            appBar: AppBar(
              title: Text('$name\'s Profile'),
              backgroundColor: CustomColors().primary,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    AnimalImagesCarousel(
                      images: images,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FavouriteButton(
                        animalDetailsController: animalDetailsController),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _getAnimalTypeAsString(animalType),
                          style: TextStyle(
                              color: CustomColors().primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 38),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Sex: ${sex.name.split('.').last.capitalize()}'),
                            Text(
                                'Age: ${ageGroup.years} years, ${ageGroup.months} months'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Colour: ${colour.capitalize()}'),
                            Text(
                                'Secondary Colour: ${secondaryColour.capitalize()}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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

  // Widget _animalPicturesCarousel(List<String> images) {
  //   int index = 0;
  //   return Column(
  //     children: [
  //       CarouselSlider.builder(
  //         itemCount: images.length,
  //         itemBuilder: (BuildContext context, int index, int realIndex) {
  //           return Container(
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                 fit: BoxFit.cover,
  //                 image: NetworkImage(images[index]),
  //               ),
  //             ),
  //           );
  //         },
  //         options: CarouselOptions(
  //             height: 300,
  //             enableInfiniteScroll: false,
  //             enlargeCenterPage: true,
  //             onPageChanged: (id, carouselChangeReason) {
  //               index = id;
  //             }),
  //       ),
  //       CarouselIndicator(
  //         count: images.length,
  //         index: index,
  //         color: CustomColors().grey,
  //         activeColor: CustomColors().primary,
  //       ),
  //     ],
  //   );
  // }

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
  final String description;
  final List<String> behaviour;
  final List<String> breed;
  final List<String> medical;

  const AnimalInfoExpansionList(
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
      elevation: 8,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isOpen[panelIndex] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: CustomColors().disabled,
          isExpanded: _isOpen[0],
          headerBuilder: (BuildContext context, bool state) {
            return const Text('Description');
          },
          body: Text(widget.description),
        ),
        ExpansionPanel(
          backgroundColor: CustomColors().disabled,
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
          backgroundColor: CustomColors().disabled,
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
          backgroundColor: CustomColors().disabled,
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
