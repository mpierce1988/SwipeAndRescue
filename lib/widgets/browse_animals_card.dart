// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/animal_type.dart';
import 'package:swipeandrescue/services/data_service.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/animal_details/animal_details_screen.dart';

class BrowseAnimalsCard extends StatelessWidget {
  final Animal animal;
  final int width;
  final int height;
  double ratio = .8;

  BrowseAnimalsCard(
      {Key? key,
      required this.animal,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      height: width.toDouble() * ratio,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            // navigate to animal details page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AnimalDetailsScreen(animalId: animal.animalID),
              ),
            );
          },
          child: Column(
            children: [
              Flexible(
                  flex: 8,
                  child: NetworkImageBuilder(
                    animalID: animal.animalID,
                  )),
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(child: _avatarImage(animal)),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(animal.name,
                                style: TextStyle(
                                    color: CustomColors().textDisplay,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${_getAnimalTypeAsString(animal.animalType)} - ${animal.ageGroup.years} years ${animal.ageGroup.months} months')
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
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

  Widget _avatarImage(Animal animal) {
    return CircleAvatar(
      backgroundImage: NetworkImage(animal.images[0]),
      backgroundColor: CustomColors().success,
    );
  }
}

class NetworkImageBuilder extends StatefulWidget {
  final String animalID;

  const NetworkImageBuilder({Key? key, required this.animalID})
      : super(key: key);

  @override
  State<NetworkImageBuilder> createState() => _NetworkImageBuilderState();
}

class _NetworkImageBuilderState extends State<NetworkImageBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService().getFirstAnimalImage(widget.animalID),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _circularProgressIndicator();
        } else if (snapshot.hasError) {
          return _redCircle();
        } else if (snapshot.hasData && snapshot.data! != '') {
          return _networkImage(snapshot.data!);
        }
        // url is empty
        return _redCircle();
      },
    );
  }

  Widget _circularProgressIndicator() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        //image: DecorationImage(
        //fit: BoxFit.cover,
        // debug just show local image
        //image: NetworkImageBuilder(animalID: animal.animalID),
        //image: NetworkImage(animal.imageURL),
        //),
      ),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _redCircle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        image: const DecorationImage(
          fit: BoxFit.cover,
          // debug just show local image
          image: AssetImage('assets/redcircle.png'),
          //image: NetworkImage(animal.imageURL),
          //),
        ),
      ),
    );
  }

  Widget _networkImage(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
          fit: BoxFit.cover,
          // debug just show local image
          //image: NetworkImageBuilder(animalID: animal.animalID),
          image: NetworkImage(url),
        ),
      ),
    );
  }
}
