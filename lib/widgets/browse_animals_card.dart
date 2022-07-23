import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      // debug just show local image
                      image: AssetImage('assets/dog.jpg'),
                      //image: NetworkImage(animal.imageURL),
                    ),
                  ),
                ),
              ),
              Flexible(flex: 1, child: Text(animal.name))
            ],
          ),
        ),
      ),
    );
  }
}
