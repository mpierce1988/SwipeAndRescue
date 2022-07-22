import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/views/animal_details/animal_details_screen.dart';

class BrowseAnimalsCard extends StatelessWidget {
  final Animal animal;
  const BrowseAnimalsCard({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(animal.imageURL),
                ),
              ),
            ),
            Text(animal.name)
          ],
        ),
      ),
    );
  }
}
