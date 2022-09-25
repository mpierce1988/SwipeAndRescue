import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/select_animals_to_delete_controller.dart';
import 'package:swipeandrescue/models/controller_state.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:swipeandrescue/theme.dart';

class SelectAnimalsToDeleteScreen extends StatelessWidget {
  const SelectAnimalsToDeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SelectAnimalsToDeleteController(),
        builder: (context, widget) {
          return _buildLayoutForControllerState(
              Provider.of<SelectAnimalsToDeleteController>(context), context);
        });
  }

  Widget _buildLayoutForControllerState(
      SelectAnimalsToDeleteController selectAnimalsToDeleteController,
      BuildContext context) {
    if (selectAnimalsToDeleteController.controllerState ==
            ControllerState.initialized ||
        selectAnimalsToDeleteController.controllerState ==
            ControllerState.loading) {
      // show loading icon
      return Scaffold(
        appBar: AppBar(title: const Text("Select Animals to Delete")),
        body: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    } else if (selectAnimalsToDeleteController.controllerState ==
        ControllerState.hasError) {
      // show error message
      return Scaffold(
        appBar: AppBar(title: const Text("An error has occured")),
        body: const Center(
          child: Text('An error has occured'),
        ),
      );
    }

    // else show animals to delete

    return _animalsToDeleteList(context);
  }

  Widget _animalsToDeleteList(BuildContext context) {
    SelectAnimalsToDeleteController selectAnimalsToDeleteController =
        Provider.of<SelectAnimalsToDeleteController>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors().error,
          title: const Text('Delete Animals'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CustomColors().error)),
              onPressed: () {
                _selectDeselectAll(selectAnimalsToDeleteController);
              },
              //child: const Text('Select All'),
              child: const Icon(FontAwesomeIcons.listCheck),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CustomColors().error)),
              onPressed: () {
                selectAnimalsToDeleteController.deleteSelectedAnimals(context);
              },
              child: const Icon(FontAwesomeIcons.trashCan),
            )
          ],
        ),
        body: _multiSelectCardLayout(selectAnimalsToDeleteController));
  }

  void _selectDeselectAll(
      SelectAnimalsToDeleteController selectAnimalsToDeleteController) {
    if (!_allOptionsSelected(selectAnimalsToDeleteController)) {
      selectAnimalsToDeleteController.multiSelectController.selectAll();
    } else {
      selectAnimalsToDeleteController.multiSelectController.deselectAll();
    }
  }

  bool _allOptionsSelected(
      SelectAnimalsToDeleteController selectAnimalsToDeleteController) {
    return selectAnimalsToDeleteController.multiSelectController
            .getSelectedItems()
            .length ==
        selectAnimalsToDeleteController.animals.length;
  }

  MultiSelectContainer<dynamic> _multiSelectContainer(
      SelectAnimalsToDeleteController selectAnimalsToDeleteController) {
    return MultiSelectContainer(
      alignments: const MultiSelectAlignments(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max),
      controller: selectAnimalsToDeleteController.multiSelectController,
      items: List.generate(
        selectAnimalsToDeleteController.animals.length,
        (index) => getAnimalMultiSelectCard(
            selectAnimalsToDeleteController.animals[index].animalID,
            selectAnimalsToDeleteController.animals[index].images[0],
            selectAnimalsToDeleteController.animals[index].name),
      ),
      onChange: (allAvailableItems, selectedItem) {},
    );
  }

  MultiSelectCard getAnimalMultiSelectCard(
      String value, String imageUrl, String title) {
    return MultiSelectCard(
        value: value,
        child: SizedBox(
          width: 200,
          height: 50,
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            Flexible(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(8.0), child: Text(title)))
          ]),
        ));
  }

  MultiSelectCheckList _multiSelectCardLayout(
      SelectAnimalsToDeleteController selectAnimalsToDeleteController) {
    return MultiSelectCheckList(
      controller: selectAnimalsToDeleteController.multiSelectController,
      items: List.generate(
        selectAnimalsToDeleteController.animals.length,
        ((index) => CheckListCard(
            value: selectAnimalsToDeleteController.animals[index].animalID,
            title: Text(selectAnimalsToDeleteController.animals[index].name),
            subtitle: Text(selectAnimalsToDeleteController
                .animals[index].animalType
                .toString()
                .split('.')
                .last),
            selectedColor: Colors.white,
            checkColor: Colors.indigo,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)))),
      ),
      onChange: (allSelectedItems, selectedItem) {},
    );
  }
}
