import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/favourites_controller.dart';
import 'package:swipeandrescue/models/controller_state.dart';

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
        child: Text(
          'No favourite animals. Please add some animals to your favourites list!',
          textAlign: TextAlign.center,
        ),
      );
    }

    // return a list view of favourite animals
    return ListView.builder(
        itemCount: Provider.of<FavouritesController>(context).animals.length,
        itemBuilder: (context, id) {
          return ListTile(
              title: Text(
                  Provider.of<FavouritesController>(context).animals[id].name),
              subtitle: Text(Provider.of<FavouritesController>(context)
                  .animals[id]
                  .animalType
                  .toString()
                  .split('.')
                  .last),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    Provider.of<FavouritesController>(context)
                        .animals[id]
                        .images[0]),
              ));
        });
  }

  refresh() {
    if (favouritesController != null) {
      favouritesController!.getFavouriteAnimalsForUser();
    }
  }
}
