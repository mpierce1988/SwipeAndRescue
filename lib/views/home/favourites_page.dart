import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/favourites_controller.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/controller_state.dart';
import 'package:swipeandrescue/utilities.dart';
import 'package:swipeandrescue/views/animal_details/animal_details_screen.dart';

import '../../services/auth_service.dart';

class FavouritesPage extends StatelessWidget {
  final String userID = AuthenticationService().appUser.userId;
  FavouritesController? favouritesController;
  FavouritesPage({Key? key}) : super(key: key) {
    favouritesController = FavouritesController(userID: userID);
    favouritesController!.getFavouriteAnimalsForUser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: favouritesController!,
        builder: (context, widget) {
          if (Provider.of<FavouritesController>(context).controllerState ==
                  ControllerState.initialized ||
              Provider.of<FavouritesController>(context).controllerState ==
                  ControllerState.loading) {
            // show loading circle
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (Provider.of<FavouritesController>(context)
                  .controllerState ==
              ControllerState.hasError) {
            // show error message
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text('An error has occured, please try again',
                    textAlign: TextAlign.center),
              ),
            );
          }

          return listOfFavouriteAnimals(context);
          // else, show list of favourite animals
        });
  }

  Widget listOfFavouriteAnimals(BuildContext context) {
    // show message if no animals are favourited
    if (Provider.of<FavouritesController>(context).animals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(36, 0, 36, 0),
          child: Text(
              'No favourite animals. Please add some animals to your favourites list!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    }

    // return a list view of favourite animals
    return ListView.builder(
        itemCount: Provider.of<FavouritesController>(context).animals.length,
        itemBuilder: (context, id) {
          Animal animalToShow =
              Provider.of<FavouritesController>(context).animals[id];
          return ListTile(
            title: Text(
                Provider.of<FavouritesController>(context).animals[id].name),
            subtitle: Text(Provider.of<FavouritesController>(context)
                .animals[id]
                .animalType
                .toString()
                .split('.')
                .last
                .capitalize()),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(animalToShow.images[0]),
            ),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: ((context) =>
                        AnimalDetailsScreen(animalId: animalToShow.animalID))))
                .then((value) {
              refresh();
            }),
          );
        });
  }

  refresh() {
    if (favouritesController != null) {
      favouritesController!.getFavouriteAnimalsForUser();
    }
  }
}
