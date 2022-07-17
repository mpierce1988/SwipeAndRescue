import 'package:swipeandrescue/models/animal_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'animal_model.g.dart';

@JsonSerializable()
class Animal {
  String animalID;
  String name;
  AnimalType animalType;
  String imageURL;

  Animal(
      {this.animalID = '',
      this.name = '',
      this.animalType = AnimalType.other,
      this.imageURL = ''});

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}
