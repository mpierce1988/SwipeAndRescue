import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/constants.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';
import 'package:swipeandrescue/services/dialog_service.dart';
import 'package:swipeandrescue/views/add_animals/add_animal_elements.dart';
import 'package:swipeandrescue/views/add_animals/image_selection_column.dart';
import 'package:swipeandrescue/views/add_animals/text_entry_column.dart';

class AddAnimalsScreen extends StatelessWidget {
  final AddAnimalsController addAnimalsController = AddAnimalsController();
  final AddAnimalElements addAnimalElements = AddAnimalElements();

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
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: formKey,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth <= Constants().mediumWidth) {
                        // small layout
                        return _smallLayout(context);
                      } else if (constraints.maxWidth <=
                          Constants().largeWidth) {
                        // medium layout
                        return _mediumLayout(context);
                      }
                      // large layout
                      return _smallLayout(context);
                    }),
                  )),
            ),
          );
        });
  }

  Widget _mediumLayout(BuildContext context) {
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
        child: _smallLayout(context),
      ),
    );
  }

  // Layouts
  Widget _smallLayout(BuildContext context) {
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

  // Elements

  ElevatedButton _submitButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(FontAwesomeIcons.thumbsUp),
      label: const Text('Submit Animal'),
      onPressed: () {
        if (Provider.of<AddAnimalsController>(context, listen: false)
            .images
            .isEmpty) {
          // show a dialog prompt telling the user to upload at least one image
          DialogService().showImageRequiredDialog(context);
          return;
        } else if (formKey.currentState!.validate()) {
          // submit animal
          DialogService().showProcessSubmitingDialog(context,
              Provider.of<AddAnimalsController>(context, listen: false));
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
      images: Provider.of<AddAnimalsController>(context).images,
    );
  }

  TextFormField _descriptionTextField(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: 5,
      //keyboardType: TextInputType.multiline,
      controller: Provider.of<AddAnimalsController>(context).description,
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
      entries: Provider.of<AddAnimalsController>(context).medical,
    );
  }

  TextEntryColumn _breedsColumn(BuildContext context) {
    return TextEntryColumn(
      entries: Provider.of<AddAnimalsController>(context).breeds,
    );
  }

  TextEntryColumn _behavioursColumn(BuildContext context) {
    return TextEntryColumn(
        entries: Provider.of<AddAnimalsController>(context).behaviours);
  }

  Widget _secondaryColourDropdown(BuildContext context) {
    return addAnimalElements.secondaryColourDropdown(
        context, Provider.of<AddAnimalsController>(context));
  }

  Widget _colourDropdown(BuildContext context) {
    return addAnimalElements.colourDropdown(
        context, Provider.of<AddAnimalsController>(context));
  }

  Widget _ageMonthsDropdown(BuildContext context) {
    return addAnimalElements.ageMonthsDropdown(
        context, Provider.of<AddAnimalsController>(context));
  }

  Widget _ageYearsDropdown(BuildContext context) {
    return addAnimalElements.ageYearsDropdown(
        context, Provider.of<AddAnimalsController>(context));
  }

  Widget _sexDropdown(BuildContext context) {
    return addAnimalElements.sexDropdownBox(
        context, Provider.of<AddAnimalsController>(context));
  }

  Widget _animalDropdown(BuildContext context) {
    return addAnimalElements.animalTypeDropdown(
        context, Provider.of<AddAnimalsController>(context));
  }

  TextFormField _nameField(BuildContext context) {
    return TextFormField(
      controller: Provider.of<AddAnimalsController>(context, listen: false)
          .nameTextEditingController,
      validator: (value) =>
          Provider.of<AddAnimalsController>(context, listen: false)
              .validateName(),
    );
  }
}
