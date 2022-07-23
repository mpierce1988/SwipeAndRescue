import 'package:flutter/material.dart';
import 'package:swipeandrescue/constants.dart';
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
            return _displayAnimals(snapshot.data!);
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
          return BrowseAnimalsCard(
            animal: animals[index],
            width: 400,
            height: 400,
          );
        }),
      ),
    );
  }

  Widget _browseAnimalsGrid(List<Animal> animals) {
    debugPrint('Using animals grid view...');
    return Container(
      padding: const EdgeInsets.all(30),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: animals.length,
          itemBuilder: (BuildContext context, int idx) {
            return BrowseAnimalsCard(
              animal: animals[idx],
              width: 800,
              height: 800,
            );
          }),
    );
  }

  Widget _displayAnimals(List<Animal> animals) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= Constants().mediumWidth) {
          // small layout
          return _browseAnimalsColumn(animals);
        } else if (constraints.maxWidth <= Constants().largeWidth) {
          // medium layout
          return _browseAnimalsGrid(animals);
        }

        // large layout
        return _browseAnimalsGrid(animals);
      },
    );
  }
}
