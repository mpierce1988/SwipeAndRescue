import 'package:swipeandrescue/models/animal_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'animal_model.g.dart';

@JsonSerializable()
class Animal {
  String animalID;
  String name;
  AnimalType animalType;
  String imageURL;
  List<String> images;
  AgeGroup ageGroup;
  List<String> behaviours;
  List<String> breed;
  String colour;
  String secondaryColour;
  String description;
  List<String> medical;
  bool neutered;
  Sex sex;

  Animal(
      {this.animalID = '',
      this.name = '',
      this.animalType = AnimalType.other,
      this.imageURL = '',
      this.ageGroup = const AgeGroup(),
      this.behaviours = const [],
      this.breed = const [],
      this.colour = '',
      this.secondaryColour = '',
      this.description = '',
      this.medical = const [],
      this.neutered = false,
      this.sex = Sex.unknown,
      this.images = const <String>[]});

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}

@JsonSerializable()
class AgeGroup {
  final int months;
  final int years;

  const AgeGroup({this.months = 0, this.years = 0});

  factory AgeGroup.fromJson(Map<String, dynamic> json) =>
      _$AgeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AgeGroupToJson(this);
}

enum Sex { male, female, unknown }
