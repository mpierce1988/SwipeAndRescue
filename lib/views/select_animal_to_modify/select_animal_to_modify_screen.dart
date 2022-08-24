import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/select_animal_to_modify_controller.dart';
import 'package:swipeandrescue/models/controller_state.dart';

class SelectAnimalToModifyScreen extends StatelessWidget {
  const SelectAnimalToModifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectAnimalToModifyController(),
      builder: (BuildContext context, Widget? widget) {
        SelectAnimalToModifyController selectAnimalToModifyController =
            Provider.of<SelectAnimalToModifyController>(context);
        return Scaffold(
            appBar: AppBar(title: const Text('Select an Animal to Modify')),
            body: _showBodyForState(selectAnimalToModifyController));
      },
    );
  }

  Widget _showBodyForState(
      SelectAnimalToModifyController selectAnimalToModifyController) {
    if (selectAnimalToModifyController.controllerState ==
            ControllerState.initialized ||
        selectAnimalToModifyController.controllerState ==
            ControllerState.loading) {
      // initializing or loading
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (selectAnimalToModifyController.controllerState ==
        ControllerState.hasError) {
      // error has occured
      return const Center(child: Text('An error has occured'));
    }
    // else, loading is complete
    return _showListOfAnimals(selectAnimalToModifyController);
  }

  Widget _showListOfAnimals(
      SelectAnimalToModifyController selectAnimalToModifyController) {
    return ListView.separated(
      itemCount: selectAnimalToModifyController.animals.length,
      separatorBuilder: (context, index) {
        return Divider(color: Theme.of(context).primaryColor);
      },
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(selectAnimalToModifyController.animals[index].name),
          subtitle: Text(selectAnimalToModifyController
              .animals[index].animalType
              .toString()
              .split('.')
              .last),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                selectAnimalToModifyController.animals[index].images[0]),
          ),
        );
      },
    );
  }
}
