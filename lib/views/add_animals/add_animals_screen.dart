import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';

class AddAnimalsScreen extends StatelessWidget {
  final AddAnimalsController addAnimalsController = AddAnimalsController();

  final formKey = GlobalKey<FormState>();

  AddAnimalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addAnimalsController,
      builder: (context, widget) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Animal'),
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Animal Type:'),
                      const SizedBox(height: 20),
                      _animalTypeDropdown(context),
                      const SizedBox(height: 20),
                      const Text('Name:'),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: Provider.of<AddAnimalsController>(context,
                                listen: false)
                            .nameTextEditingController,
                        validator: (value) =>
                            Provider.of<AddAnimalsController>(context)
                                .validateName(),
                      ),
                    ]),
              )),
        );
      },
    );
  }

  DecoratedBox _animalTypeDropdown(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              width: 3, color: Theme.of(context).secondaryHeaderColor),
          borderRadius: BorderRadius.circular(50)),
      child: DropdownButton(
        isExpanded: true,
        dropdownColor: Theme.of(context).primaryColor,
        style: const TextStyle(color: Colors.white),
        value: Provider.of<AddAnimalsController>(context).animalTypeID,
        items: const [
          DropdownMenuItem(value: 0, child: Center(child: Text('Cat'))),
          DropdownMenuItem(value: 1, child: Center(child: Text('Dog'))),
          DropdownMenuItem(value: 2, child: Center(child: Text('Rabbit'))),
          DropdownMenuItem(value: 3, child: Center(child: Text('Other'))),
        ],
        onChanged: (int? value) => addAnimalsController.setAnimalType(value!),
      ),
    );
  }
}
