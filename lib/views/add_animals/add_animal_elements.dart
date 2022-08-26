import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/constants.dart';
import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/colours_enum.dart';
import 'package:swipeandrescue/services/dialog_service.dart';
import 'package:swipeandrescue/views/add_animals/image_selection_column.dart';
import 'package:swipeandrescue/views/add_animals/text_entry_column.dart';
import 'package:swipeandrescue/widgets/decorated_dropdown.dart';

class AddAnimalElements {
  late GlobalKey<FormState> formKey;

  AddAnimalElements() {
    formKey = GlobalKey<FormState>();
    formKey.currentState?.save();
  }
  // Layouts
  Widget responsiveLayout(
      BuildContext context, ScrollController viewScrollController) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
          controller: viewScrollController,
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: formKey,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= Constants().mediumWidth) {
                // small layout
                return smallLayout(context);
              } else if (constraints.maxWidth <= Constants().largeWidth) {
                // medium layout
                return mediumLayout(context);
              }
              // large layout
              return largeLayout(context);
            }),
          )),
    );
  }

  Widget mediumLayout(BuildContext context) {
    debugPrint('Using medium layout...');
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 5,
                blurRadius: 7)
          ]),
      //color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.fromLTRB(60, 0, 60, 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: smallLayout(context),
      ),
    );
  }

  Widget smallLayout(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(30),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        // Name field
        const Text('Name*:'),
        _nameField(context),
        const SizedBox(height: 30),
        // Animal type field
        const Text('Animal Type:'),

        _animalDropdown(context),
        const SizedBox(height: 30),
        // Sex field
        const Text("Sex:"),

        _sexDropdown(context),
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
        _behavioursColumn(context),
        const SizedBox(height: 30),
        const Text('Breeds:'),
        _breedsColumn(context),
        const SizedBox(height: 30),
        const Text('Medical:'),
        _medicalColumn(context),
        const SizedBox(height: 30),
        const Text('Description*:'),
        _descriptionTextField(context),
        const SizedBox(height: 30),
        const Text('Images:'),
        _imagesCarouselColumn(context),
        const SizedBox(height: 30),
        _submitButton(context)
      ]),
    );
  }

  Widget largeLayout(BuildContext context) {
    return Center(
      child: Container(
        width: 800,
        margin: const EdgeInsets.all(60),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 5,
              blurRadius: 7)
        ]),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: Column(
          children: [
            // name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Name:'),
                    SizedBox(
                      height: 50,
                      width: 500,
                      child: _nameField(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // animal type and sex
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Animal Type:'),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: _animalDropdown(context),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Sex:'),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: _sexDropdown(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Colour and Secondary Colour
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Colour:'),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: _colourDropdown(context),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Secondary Colour:'),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: _secondaryColourDropdown(context),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            // Age
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Age:'),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 75,
                          child: _ageYearsDropdown(context),
                        ),
                        const Text('years, '),
                        SizedBox(
                          height: 50,
                          width: 75,
                          child: _ageMonthsDropdown(context),
                        ),
                        const Text('months'),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            // Breed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Breed:'),
                    SizedBox(
                      width: 300,
                      child: _breedsColumn(context),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            // Behaviours
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Behaviours:'),
                    SizedBox(
                      width: 300,
                      child: _behavioursColumn(context),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            // Medical
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Medical:'),
                    SizedBox(
                      width: 300,
                      child: _medicalColumn(context),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            // Description
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Description:'),
                    SizedBox(
                      width: 600,
                      //height: 200,
                      child: _descriptionTextField(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Images:'),
                    SizedBox(width: 600, child: _imagesCarouselColumn(context)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Center(
              child: SizedBox(
                  width: 200, height: 50, child: _submitButton(context)),
            ),
          ],
        ),
      ),
    );
  }

  // elements
  ElevatedButton _submitButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(FontAwesomeIcons.thumbsUp),
      label: const Text('Submit Animal'),
      onPressed: () {
        if (Provider.of<AnimalFormFields>(context, listen: false)
            .images
            .isEmpty) {
          // show a dialog prompt telling the user to upload at least one image
          DialogService().showImageRequiredDialog(context);
          return;
        } else if (formKey.currentState!.validate()) {
          // submit animal
          DialogService().showProcessSubmitingDialog(
              context, Provider.of<AnimalFormFields>(context, listen: false));
          debugPrint('Add animal form passed validation');
          return;
        }

        // else, show missing required fields dialog
        DialogService().showRequiredFieldsDialog(context);
      },
    );
  }

  ImageSelectionColumn _imagesCarouselColumn(BuildContext context) {
    return ImageSelectionColumn(
      images: Provider.of<AnimalFormFields>(context).images,
    );
  }

  TextFormField _descriptionTextField(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: 5,
      //keyboardType: TextInputType.multiline,
      controller: Provider.of<AnimalFormFields>(context).description,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description';
        }

        return null;
      },
    );
  }

  TextEntryColumn _medicalColumn(BuildContext context) {
    return TextEntryColumn(
      entries: Provider.of<AnimalFormFields>(context).medical,
    );
  }

  TextEntryColumn _breedsColumn(BuildContext context) {
    return TextEntryColumn(
      entries: Provider.of<AnimalFormFields>(context).breeds,
    );
  }

  TextEntryColumn _behavioursColumn(BuildContext context) {
    return TextEntryColumn(
        entries: Provider.of<AnimalFormFields>(context).behaviours);
  }

  Widget _secondaryColourDropdown(BuildContext context) {
    return secondaryColourDropdown(
        context, Provider.of<AnimalFormFields>(context));
  }

  Widget _colourDropdown(BuildContext context) {
    return colourDropdown(context, Provider.of<AnimalFormFields>(context));
  }

  Widget _ageMonthsDropdown(BuildContext context) {
    return ageMonthsDropdown(context, Provider.of<AnimalFormFields>(context));
  }

  Widget _ageYearsDropdown(BuildContext context) {
    return ageYearsDropdown(context, Provider.of<AnimalFormFields>(context));
  }

  Widget _sexDropdown(BuildContext context) {
    return sexDropdownBox(context, Provider.of<AnimalFormFields>(context));
  }

  Widget _animalDropdown(BuildContext context) {
    return animalTypeDropdown(context, Provider.of<AnimalFormFields>(context));
  }

  TextFormField _nameField(BuildContext context) {
    return TextFormField(
      controller:
          Provider.of<AnimalFormFields>(context).nameTextEditingController,
      validator: (value) =>
          Provider.of<AnimalFormFields>(context, listen: false).validateName(),
    );
  }

  // Dropdowns
  Widget secondaryColourDropdown(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.secondaryColourID,
        dropDownMenuItems: [
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
        onChangedMethod: (value) =>
            animalFormFields.secondaryColourID = value!);
  }

  Widget colourDropdown(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.colourID,
        dropDownMenuItems: [
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
        onChangedMethod: (value) => animalFormFields.colourID = value!);
  }

  Widget ageYearsDropdown(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.ageYears,
        dropDownMenuItems: [
          for (int i = 0; i <= 20; i++)
            DropdownMenuItem(
              value: i,
              child: Center(
                child: Text(i.toString()),
              ),
            )
        ],
        onChangedMethod: (value) => animalFormFields.ageYears = value!);
  }

  Widget ageMonthsDropdown(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.ageMonths,
        dropDownMenuItems: [
          for (int i = 1; i <= 12; i++)
            DropdownMenuItem(
                value: i,
                child: Center(
                  child: Text(i.toString()),
                ))
        ],
        onChangedMethod: (value) => animalFormFields.ageMonths = value!);
  }

  Widget animalTypeDropdown(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.animalTypeID,
        dropDownMenuItems: const [
          DropdownMenuItem(
            value: 0,
            child: Center(child: Text('Cat')),
          ),
          DropdownMenuItem(
            value: 1,
            child: Center(child: Text('Dog')),
          ),
          DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Rabbit')),
          ),
          DropdownMenuItem(
              value: 3,
              child: Center(
                child: Text('Other'),
              )),
        ],
        onChangedMethod: (value) =>
            animalFormFields.animalTypeID = value as int);
  }

  Widget sexDropdownBox(
      BuildContext context, AnimalFormFields animalFormFields) {
    return DecoratedDropdown(
        valueToWatch: animalFormFields.sexID,
        dropDownMenuItems: const [
          DropdownMenuItem(
            value: 0,
            child: Center(
              child: Text('Female'),
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: Center(
              child: Text('Male'),
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Center(child: Text('Unknown')),
          ),
        ],
        onChangedMethod: (value) => animalFormFields.sexID = value as int);
  }

  // Helper functions
  String _capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }
}
