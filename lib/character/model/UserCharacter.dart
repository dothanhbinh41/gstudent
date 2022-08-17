
class UserCharacter{
  UserCharacter({this.imageCharacter,this.specialAction,this.specialTitle,this.characterId,this.classCharacter,this.totalHp});

  int characterId;
  int totalHp;
  String imageCharacter;
  String specialAction;
  String specialTitle;
  String classCharacter;

  factory UserCharacter.fromJson(Map<String, dynamic> json) => UserCharacter(
    characterId: json["characterId"],
    totalHp: json["totalHp"],
    imageCharacter: json["imageCharacter"],
    specialAction: json["specialAction"],
    specialTitle: json["specialTitle"],
    classCharacter: json["classCharacter"],
  );

  Map<String, dynamic> toJson() => {
    "characterId": characterId,
    "totalHp": totalHp,
    "imageCharacter": imageCharacter,
    "specialAction": specialAction,
    "specialTitle": specialTitle,
    "classCharacter": classCharacter,
  };


}