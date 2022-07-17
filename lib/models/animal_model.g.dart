// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
      animalID: json['animalID'] as String? ?? '',
      name: json['name'] as String? ?? '',
      animalType: json['animalType'].toString().toLowerCase() == 'dog'
          ? AnimalType.dog
          : json['animalType'].toString().toLowerCase() == 'cat'
              ? AnimalType.cat
              : json['animalType'].toString().toLowerCase() == 'rabbit'
                  ? AnimalType.rabbit
                  : AnimalType.other,
      // $enumDecodeNullable(_$AnimalTypeEnumMap, json['animalType']) ??
      //     AnimalType.other,
      imageURL: json['imageURL'] as String? ?? '',
    );

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
      'animalID': instance.animalID,
      'name': instance.name,
      'animalType': _$AnimalTypeEnumMap[instance.animalType]!,
      'imageURL': instance.imageURL,
    };

const _$AnimalTypeEnumMap = {
  AnimalType.cat: 'cat',
  AnimalType.dog: 'dog',
  AnimalType.rabbit: 'rabbit',
  AnimalType.other: 'other',
};
