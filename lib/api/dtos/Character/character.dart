// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Character> CharacterFromJson(String str) => List<Character>.from(json.decode(str).map((x) => Character.fromJson(x)));

String CharacterToJson(List<Character> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Character {
  Character({
    this.id,
    this.name,
    this.family,
    this.gender,
    this.characterClass,
    this.type,
    this.personality,
    this.physicalAppearance,
    this.ability,
    this.hp,
    this.story,
  });

  int id;
  String name;
  String family;
  String gender;
  String characterClass;
  String type;
  String personality;
  String physicalAppearance;
  String ability;
  int hp;
  String story;

  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: json["id"],
    name: json["name"],
    family: json["family"],
    gender: json["gender"],
    characterClass: json["class"],
    type: json["type"],
    personality: json["personality"],
    physicalAppearance: json["physical_appearance"],
    ability: json["ability"],
    hp: json["hp"],
    story: json["story"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "family": family,
    "gender": gender,
    "class": characterClass,
    "type": type,
    "personality": personality,
    "physical_appearance": physicalAppearance,
    "ability": ability,
    "hp": hp,
  };
}

enum Gender { NAM, N }

final genderValues = EnumValues({
  "Nữ": Gender.N,
  "Nam": Gender.NAM
});

enum Type { NHN_VT_CHNH }

final typeValues = EnumValues({
  "Nhân vật chính": Type.NHN_VT_CHNH
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
