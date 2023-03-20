import 'package:swipeandrescue/models/animal_form_fields.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/success_state.dart';
import 'package:swipeandrescue/services/data_service.dart';

class AddAnimalsController extends AnimalFormFields {
  /// Submits the animal and images to the database, and returns a success state
  /// as a response
  @override
  Future<SuccessState> submitAnimal() async {
    // create animal model
    Animal animal = createAnimalFromFormFields();

    // submit as new animal
    DataService dataService = DataService();
    SuccessState successState =
        await dataService.addAnimal(animal, imagesFromPicker).catchError((e) {
      return SuccessState.failed;
    });

    return successState;
  }
}
