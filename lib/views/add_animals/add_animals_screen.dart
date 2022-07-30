import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';
import 'package:swipeandrescue/models/colours_enum.dart';
import 'package:swipeandrescue/views/add_animals/image_selection_column.dart';
import 'package:swipeandrescue/views/add_animals/text_entry_column.dart';

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
          body: GestureDetector(
            onTap: (() {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            }),
            child: SingleChildScrollView(
              controller: addAnimalsController.viewScrollController,
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Name field
                          const Text('Name*:'),
                          TextFormField(
                            controller: Provider.of<AddAnimalsController>(
                                    context,
                                    listen: false)
                                .nameTextEditingController,
                            validator: (value) =>
                                Provider.of<AddAnimalsController>(context,
                                        listen: false)
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
                          TextEntryColumn(
                              entries:
                                  Provider.of<AddAnimalsController>(context)
                                      .behaviours),
                          const SizedBox(height: 30),
                          const Text('Breeds:'),
                          TextEntryColumn(
                            entries: Provider.of<AddAnimalsController>(context)
                                .breeds,
                          ),
                          const SizedBox(height: 30),
                          const Text('Medical:'),
                          TextEntryColumn(
                            entries: Provider.of<AddAnimalsController>(context)
                                .medical,
                          ),
                          const SizedBox(height: 30),
                          const Text('Description*:'),
                          TextFormField(
                            maxLines: null,
                            minLines: 5,
                            //keyboardType: TextInputType.multiline,
                            controller:
                                Provider.of<AddAnimalsController>(context)
                                    .description,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          const Text('Images:'),
                          ImageSelectionColumn(
                            images: Provider.of<AddAnimalsController>(context)
                                .images,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(FontAwesomeIcons.thumbsUp),
                            label: const Text('Submit Animal'),
                            onPressed: () {
                              if (Provider.of<AddAnimalsController>(context,
                                      listen: false)
                                  .images
                                  .isEmpty) {
                                // show a dialog prompt telling the user to upload at least one image
                                _showImageRequiredDialog(context);
                                return;
                              } else if (formKey.currentState!.validate()) {
                                // submit animal
                                _showProcessingSubmitionDialog(
                                    context,
                                    Provider.of<AddAnimalsController>(context,
                                        listen: false));
                                debugPrint('Add animal form passed validation');
                                return;
                              }

                              // else, show missing required fields dialog
                              _showRequiredFieldsDialog(context);
                            },
                          )
                        ]),
                  )),
            ),
          ),
        );
      },
    );
  }

  _showProcessingSubmitionDialog(
      BuildContext context, AddAnimalsController addAnimalsController) {
    bool dialogBoxActive = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: addAnimalsController.submitAnimal(context),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              debugPrint(
                  "State of Processing Dialog Box: ${snapshot.connectionState.name}");
              // get rid of current dialog box, if any
              //if (dialogBoxActive) {
              //  Navigator.pop(context);
              //}

              if (snapshot.connectionState == ConnectionState.waiting) {
                dialogBoxActive = true;
                // show waiting dialog box
                return const AlertDialog(
                  title: Text('Submitting'),
                  content: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
                dialogBoxActive = true;
                return AlertDialog(
                  title: const Text('An error has occured'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text('The following error has occured:'),
                        Text(snapshot.error.toString()),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        dialogBoxActive = false;
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              } else if (!snapshot.hasData) {
                // show generic error message
                return AlertDialog(
                  title: const Text('An error has occured'),
                  content: const Text(
                      'An error has occured. Please contact support.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        dialogBoxActive = false;
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              }

              // else, submition was successful
              return AlertDialog(
                title: const Text('Submition Successful!'),
                content: Text(
                    'Your submition for ${addAnimalsController.nameTextEditingController.text} was successful!'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      dialogBoxActive = false;
                      Navigator.pop(context);
                      // reset form fields
                      addAnimalsController.clearFormFields();
                    },
                  )
                ],
              );
            },
          );
        });
  }

  _showRequiredFieldsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Required Fields Missing'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text('Some required fields are missing information.'),
                  Text('Please check the form for required fields.')
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _showImageRequiredDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Images'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text('At least one image is required.'),
                  Text('Please add an image.')
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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

// class TextEntryColumn extends StatefulWidget {
//   final List<TextEditingController> entries;

//   const TextEntryColumn({Key? key, this.entries = const []}) : super(key: key);

//   @override
//   State<TextEntryColumn> createState() => _TextEntryColumnState();
// }

// class _TextEntryColumnState extends State<TextEntryColumn> {
//   int count = 0;
//   //List<TextEditingController> textEditingControllers = [];
//   @override
//   Widget build(BuildContext context) {
//     for (int i = 0; i < count; i++) {
//       if (i >= widget.entries.length) {
//         // list does not already have a text editing controller for this
//         // index
//         widget.entries.add(TextEditingController());
//       }
//     }
//     return Column(
//       children: [
//         for (int i = 0; i < count; i++) _newTextBox(i),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => setState(() {
//                 // only allow up to 6 fields
//                 if (widget.entries.length >= 6) return;

//                 count++;
//               }),
//               icon: const Icon(Icons.plus_one),
//               label: const Text('Add Field'),
//             ),
//             ElevatedButton.icon(
//               onPressed: (() => setState(() {
//                     // do nothing if entries is already empty
//                     if (widget.entries.isEmpty) return;
//                     // get rid of last text editing controller
//                     widget.entries.removeLast();
//                     // decrement the count
//                     count--;
//                   })),
//               icon: const Icon(FontAwesomeIcons.minus),
//               label: const Text('Remove Field'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   _newTextBox(int index) {
//     return Row(
//       children: [
//         const Flexible(flex: 1, child: Icon(Icons.arrow_right)),
//         Flexible(
//           flex: 3,
//           child: TextFormField(
//             //expands: true,
//             controller: widget.entries[index],
//           ),
//         )
//       ],
//     );
//   }
// }
