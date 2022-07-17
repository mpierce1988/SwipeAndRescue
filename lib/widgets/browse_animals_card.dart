import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/animal_model.dart';

class BrowseAnimalsCard extends StatelessWidget {
  final Animal animal;
  const BrowseAnimalsCard({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          debugPrint("Animal ${animal.name} was tapped.");
        },
        child: Column(
          children: [
            Image.network(
              animal.imageURL,
            ),
            Text(animal.name)
          ],
        ),
      ),
    );
  }
}
