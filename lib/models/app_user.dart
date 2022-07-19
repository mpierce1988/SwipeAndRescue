import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/models/shelter_model.dart';
import 'dart:convert';

class AppUser {
  String userId;
  String email;
  String displayName;
  List<Animal> favouriteAnimals;
  Shelter? shelter;
  bool isAdmin = false;

  AppUser(
      {this.userId = '',
      this.email = '',
      this.displayName = '',
      this.favouriteAnimals = const <Animal>[],
      this.shelter,
      isAdmin = false});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    AppUser appUser = AppUser(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      favouriteAnimals: json['favouriteAnimals'] != null
          ? (json['favouriteAnimals'] as List)
              .map((e) => Animal.fromJson(e))
              .toList()
          : const <Animal>[],
      shelter: json['shelter'] != null && json['shelter'].toString() != ''
          ? Shelter.fromJson(json['shelter'])
          : null,
      isAdmin: json['isAdmin'] != null
          ? json['isAdmin'] == true
              ? true
              : false
          : false,
    );

    return appUser;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'email': email,
        'displayName': displayName,
        'shelter': jsonEncode(shelter),
        'isAdmin': isAdmin == true ? 'true' : 'false',
        'favouriteAnimals': jsonEncode(favouriteAnimals),
      };
}
