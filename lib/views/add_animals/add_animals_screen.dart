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
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 30),
                        const Text('Animal Type:'),
                        const SizedBox(height: 20),
                        _animalTypeDropdown(context),
                        const SizedBox(height: 20),
                      ]),
                )),
          ),
        );
      },
    );
  }

  DecoratedBox _animalTypeDropdown(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).animalTypeID,
        [
          const DropdownMenuItem(
            value: 0,
            child: Center(child: Text('Cat')),
          ),
          const DropdownMenuItem(
            value: 1,
            child: Center(child: Text('Dog')),
          ),
          const DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Rabbit')),
          ),
          const DropdownMenuItem(
              value: 3,
              child: Center(
                child: Text('Other'),
              )),
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .animalTypeID = value as int);
  }

  DecoratedBox _dropdown(
      BuildContext context,
      int? valueToWatch,
      List<DropdownMenuItem<int>> dropDownMenuItems,
      Function(int? value) onChangedMethod) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              width: 3, color: Theme.of(context).secondaryHeaderColor),
          borderRadius: BorderRadius.circular(50)),
      child: DropdownButton<int?>(
        isExpanded: true,
        dropdownColor: Theme.of(context).primaryColor,
        style: const TextStyle(color: Colors.white),
        value: valueToWatch,
        items: dropDownMenuItems,
        onChanged: (value) {
          onChangedMethod(value!);
        },
      ),
    );
  }
}
