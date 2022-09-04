import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/animal_details_controller.dart';
import 'package:swipeandrescue/models/controller_state.dart';

class FavouriteButton extends StatelessWidget {
  final AnimalDetailsController animalDetailsController;
  const FavouriteButton({Key? key, required this.animalDetailsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: animalDetailsController,
        builder: (context, widget) {
          if (Provider.of<AnimalDetailsController>(context).favouriteState ==
                  ControllerState.initialized ||
              Provider.of<AnimalDetailsController>(context).favouriteState ==
                  ControllerState.loading) {
            // still loading favourite information
            // show disabled button
            return _showFavouriteButtonDisabled(context);
          }

          // else, favourite information is done loading
          // show enabled button
          return _showFavouriteButtonEnabled(context);
        });
  }

  Widget _showFavouriteButtonEnabled(BuildContext context) {
    bool isFavourited =
        Provider.of<AnimalDetailsController>(context, listen: false)
            .isFavourited;

    if (isFavourited) {
      return _createFavouriteButton(context, Colors.blue, Colors.red,
          'Remove From Favourites', _toggleFavourite);
    }

    // else, show button as unfavourited
    return _createFavouriteButton(context, Colors.grey, Colors.white,
        'Add to Favourites', _toggleFavourite);
  }

  Widget _showFavouriteButtonDisabled(BuildContext context) {
    return _createFavouriteButton(
        context, Colors.grey, Colors.grey.shade900, 'Hold On...', (context) {});
  }

  Widget _createFavouriteButton(
      BuildContext context,
      Color color,
      Color iconColor,
      String text,
      Function(BuildContext context) onPressedFunction) {
    return ElevatedButton.icon(
      icon: Icon(
        FontAwesomeIcons.heart,
        color: iconColor,
      ),
      label: Text(text),
      onPressed: () => onPressedFunction(context),
    );
  }

  _toggleFavourite(BuildContext context) async {
    await Provider.of<AnimalDetailsController>(context, listen: false)
        .toggleFavourite();
  }
}
