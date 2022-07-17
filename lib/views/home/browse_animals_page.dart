import 'package:flutter/material.dart';
import 'package:swipeandrescue/controllers/browse_animals_controller.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/widgets/browse_animals_card.dart';

class BrowseAnimalsPage extends StatelessWidget {
  BrowseAnimalsPage({Key? key}) : super(key: key);

  final BrowseAnimalsController browseAnimalsController =
      BrowseAnimalsController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: browseAnimalsController.getAnimals(),
        builder: (context, AsyncSnapshot<List<Animal>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show circular loading
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            // show error message
            return Center(
              child: Text(
                  'The following error has occured: ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // show animal results
            return _browseAnimalsColumn(snapshot.data!);
          }

          // else no results were found
          return const Center(
            child: Text('No animals were found, sorry.'),
          );
        });
  }

  Widget _browseAnimalsColumn(List<Animal> animals) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: animals.length,
        itemBuilder: ((context, index) {
          return BrowseAnimalsCard(animal: animals[index]);
        }),
      ),
    );
  }
}
