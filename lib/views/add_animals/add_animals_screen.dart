import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';
import 'package:swipeandrescue/models/colours_enum.dart';

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
                        // Name field
                        const Text('Name:'),
                        TextFormField(
                          controller: Provider.of<AddAnimalsController>(context,
                                  listen: false)
                              .nameTextEditingController,
                          validator: (value) =>
                              Provider.of<AddAnimalsController>(context)
                                  .validateName(),
                        ),
                        const SizedBox(height: 30),
                        // Animal type field
                        const Text('Animal Type:'),

                        _animalTypeDropdown(context),
                        const SizedBox(height: 30),
                        // Sex field
                        const Text("Sex:"),

                        _sexDropdownBox(context),
                        const SizedBox(
                          height: 30,
                        ),
                        // Age field
                        const Text("Age:"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Years
                            Flexible(
                              flex: 1,
                              child: _ageYearsDropdown(context),
                            ),
                            const Flexible(flex: 1, child: Text('years, ')),
                            // Months
                            Flexible(
                              flex: 1,
                              child: _ageMonthsDropdown(context),
                            ),
                            const Text('months.'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text('Colour:'),
                        _colourDropdown(context),
                        const SizedBox(height: 30),
                        const Text('Secondary Colour:'),
                        _secondaryColourDropdown(context),
                        const SizedBox(height: 30),
                        const Text('Behaviours:'),
                        TextEntryList(
                            entries: Provider.of<AddAnimalsController>(context)
                                .behaviours),
                      ]),
                )),
          ),
        );
      },
    );
  }

  DecoratedBox _secondaryColourDropdown(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).secondaryColour,
        [
          for (Colour value in Colour.values)
            DropdownMenuItem(
              value: value.index,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: value.color, shape: BoxShape.circle),
                    ),
                    Text(_capitalize(value.toString().split('.').last)),
                  ],
                ),
              ),
            )
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .secondaryColour = value!);
  }

  DecoratedBox _colourDropdown(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).colour,
        [
          for (Colour value in Colour.values)
            DropdownMenuItem(
              value: value.index,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: value.color, shape: BoxShape.circle),
                    ),
                    Text(_capitalize(value.toString().split('.').last)),
                  ],
                ),
              ),
            )
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .colour = value!);
  }

  DecoratedBox _ageYearsDropdown(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).ageYears,
        [
          for (int i = 0; i <= 20; i++)
            DropdownMenuItem(
              value: i,
              child: Center(
                child: Text(i.toString()),
              ),
            )
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .ageYears = value!);
  }

  DecoratedBox _ageMonthsDropdown(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).ageMonths,
        [
          for (int i = 1; i <= 12; i++)
            DropdownMenuItem(
                value: i,
                child: Center(
                  child: Text(i.toString()),
                ))
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .ageMonths = value!);
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

  DecoratedBox _sexDropdownBox(BuildContext context) {
    return _dropdown(
        context,
        Provider.of<AddAnimalsController>(context).sexID,
        [
          const DropdownMenuItem(
            value: 0,
            child: Center(
              child: Text('Female'),
            ),
          ),
          const DropdownMenuItem(
            value: 1,
            child: Center(
              child: Text('Male'),
            ),
          ),
          const DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Unknown')),
          ),
        ],
        (value) => Provider.of<AddAnimalsController>(context, listen: false)
            .sexID = value as int);
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

  String _capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }
}

class TextEntryList extends StatefulWidget {
  List<String> entries;

  TextEntryList({Key? key, this.entries = const []}) : super(key: key);

  @override
  State<TextEntryList> createState() => _TextEntryListState();
}

class _TextEntryListState extends State<TextEntryList> {
  int count = 0;
  List<TextEditingController> textEditingControllers = [];
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < count; i++) {
      if (i >= textEditingControllers.length) {
        // list does not already have a text editing controller for this
        // index
        textEditingControllers.add(TextEditingController());
      }
    }
    return Column(
      children: [
        for (int i = 0; i < count; i++) _newTextBox(i),
        ElevatedButton.icon(
          onPressed: () => setState(() {
            count++;
          }),
          icon: const Icon(Icons.plus_one),
          label: const Text('Add Field'),
        ),
      ],
    );
  }

  _newTextBox(int index) {
    return Row(
      children: [
        const Flexible(flex: 1, child: Icon(Icons.arrow_right)),
        Flexible(
          flex: 3,
          child: TextFormField(
            //expands: true,
            controller: textEditingControllers[index],
          ),
        )
      ],
    );
  }
}
