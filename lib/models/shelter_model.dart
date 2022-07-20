class Shelter {
  final String shelterId;
  final String shelterName;

  Shelter({required this.shelterId, required this.shelterName});

  factory Shelter.fromJson(Map<String, dynamic> json) {
    Shelter shelter = Shelter(
        shelterId: json['shelterId'] ?? '',
        shelterName: json['shelterName'] ?? '');

    return shelter;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'shelterId': shelterId,
        'shelterName': shelterName,
      };
}
