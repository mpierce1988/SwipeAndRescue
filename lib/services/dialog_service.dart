import 'package:flutter/material.dart';
import 'package:swipeandrescue/controllers/add_animals_controller.dart';

class DialogService {
  DialogService();

  void showProcessSubmitingDialog(
      BuildContext context, AddAnimalsController addAnimalsController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: addAnimalsController.submitAnimal(context),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              debugPrint(
                  "State of Processing Dialog Box: ${snapshot.connectionState.name}");

              if (snapshot.connectionState == ConnectionState.waiting) {
                // show waiting dialog box
                return const AlertDialog(
                  title: Text('Submitting'),
                  content: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
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

  void showRequiredFieldsDialog(BuildContext context) {
    showDialog(
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

  void showImageRequiredDialog(BuildContext context) {
    showDialog(
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
}
