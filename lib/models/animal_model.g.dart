// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
      animalID: json['animalID'] as String? ?? '',
      name: json['name'] as String? ?? '',
      animalType:
          $enumDecodeNullable(_$AnimalTypeEnumMap, json['animalType']) ??
              AnimalType.other,
      imageURL: json['imageURL'] as String? ?? '',
      ageGroup: json['ageGroup'] == null
          ? const AgeGroup()
          : AgeGroup.fromJson(json['ageGroup'] as Map<String, dynamic>),
      behaviours: (json['behaviours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      breed:
          (json['breed'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      colour: json['colour'] as String? ?? '',
      secondaryColour: json['secondaryColour'] as String? ?? '',
      description: json['description'] as String? ?? '',
      medical: (json['medical'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      neutered: json['neutered'] as bool? ?? false,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.unknown,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      shelterID: json['shelterID'] as String? ?? '',
      shelterName: json['shelterName'] as String? ?? '',
      addedByUserID: json['addedByUserID'] as String? ?? '',
    );

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
      'animalID': instance.animalID,
      'name': instance.name,
      'animalType': _$AnimalTypeEnumMap[instance.animalType]!,
      'imageURL': instance.imageURL,
      'images': instance.images,
      'ageGroup': _$AgeGroupToJson(instance.ageGroup),
      'behaviours': instance.behaviours,
      'breed': instance.breed,
      'colour': instance.colour,
      'secondaryColour': instance.secondaryColour,
      'description': instance.description,
      'medical': instance.medical,
      'neutered': instance.neutered,
      'sex': _$SexEnumMap[instance.sex]!,
      'shelterID': instance.shelterID,
      'shelterName': instance.shelterName,
      'addedByUserID': instance.addedByUserID,
    };

const _$AnimalTypeEnumMap = {
  AnimalType.cat: 'cat',
  AnimalType.dog: 'dog',
  AnimalType.rabbit: 'rabbit',
  AnimalType.other: 'other',
};

const _$SexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
  Sex.unknown: 'unknown',
};

AgeGroup _$AgeGroupFromJson(Map<String, dynamic> json) => AgeGroup(
      months: json['months'] as int? ?? 0,
      years: json['years'] as int? ?? 0,
    );

Map<String, dynamic> _$AgeGroupToJson(AgeGroup instance) => <String, dynamic>{
      'months': instance.months,
      'years': instance.years,
    };
