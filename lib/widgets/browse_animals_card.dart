// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/services/data_service.dart';
import 'package:swipeandrescue/views/animal_details/animal_details_screen.dart';

class BrowseAnimalsCard extends StatelessWidget {
  final Animal animal;
  final int width;
  final int height;

  const BrowseAnimalsCard(
      {Key? key,
      required this.animal,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ImageProvider imageProvider = Image.network(DataService().getFirstAnimalImage(animal.animalID), );

    debugPrint('Browse Animal Card is (re)building...');

    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
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
                  flex: 3,
                  child: NetworkImageBuilder(
                    animalID: animal.animalID,
                  )),
              Flexible(flex: 1, child: Text(animal.name))
            ],
          ),
        ),
      ),
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
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
