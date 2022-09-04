import 'package:json_annotation/json_annotation.dart';
part 'favourite_model.g.dart';

@JsonSerializable()
class Favourite {
  String userID;
  String animalID;

  Favourite({required this.userID, required this.animalID});

  factory Favourite.fromJson(Map<String, dynamic> json) =>
      _$FavouriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavouriteToJson(this);
}
