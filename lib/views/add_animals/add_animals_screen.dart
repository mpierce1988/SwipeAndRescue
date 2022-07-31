import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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

                          addAnimalElements.animalTypeDropdown(context,
                              Provider.of<AddAnimalsController>(context)),
                          const SizedBox(height: 30),
                          // Sex field
                          const Text("Sex:"),

                          addAnimalElements.sexDropdownBox(context,
                              Provider.of<AddAnimalsController>(context)),
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
                                child: addAnimalElements.ageYearsDropdown(
                                    context,
                                    Provider.of<AddAnimalsController>(context)),
                              ),
                              const Flexible(flex: 1, child: Text('years, ')),
                              // Months
                              Flexible(
                                flex: 1,
                                child: addAnimalElements.ageMonthsDropdown(
                                    context,
                                    Provider.of<AddAnimalsController>(context)),
                              ),
                              const Text('months.'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text('Colour:'),
                          addAnimalElements.colourDropdown(context,
                              Provider.of<AddAnimalsController>(context)),
                          const SizedBox(height: 30),
                          const Text('Secondary Colour:'),
                          addAnimalElements.secondaryColourDropdown(context,
                              Provider.of<AddAnimalsController>(context)),
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
                                DialogService()
                                    .showImageRequiredDialog(context);
                                return;
                              } else if (formKey.currentState!.validate()) {
                                // submit animal
                                DialogService().showProcessSubmitingDialog(
                                    context,
                                    Provider.of<AddAnimalsController>(context,
                                        listen: false));
                                debugPrint('Add animal form passed validation');
                                return;
                              }

                              // else, show missing required fields dialog
                              DialogService().showRequiredFieldsDialog(context);
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
}
