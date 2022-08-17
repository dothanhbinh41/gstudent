
import 'package:gstudent/character/model/UserCharacter.dart';

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.exp,
    this.coin,
    this.accessToken,
    this.character
  });


  int id;
  String name;
  String email;
  int exp;
  int coin;
  String accessToken;
  UserCharacter character;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    exp: json["exp"],
    coin: json["coin"] != null ?  json["coin"] : 0,
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "exp": exp,
    "coin":coin,
    "access_token": accessToken,
  };

}
