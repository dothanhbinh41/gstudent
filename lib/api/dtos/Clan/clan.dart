class Clan {
  Clan({
    this.id,
    this.userClanId,
    this.name,
    this.characterId,
    this.isApprove,
    this.isSigned
  });

  bool isApprove;
  int id;
  int userClanId;
  String name;
  int characterId;
  bool isSigned ;

  factory Clan.fromJson(Map<String, dynamic> json) => Clan(
    id: json["id"] != "" && json["id"] != null ? json["id"] : null,
    userClanId: json["user_clan_id"],
    name: json["name"],
    characterId: json["character_id"],
    isSigned: json["is_signed_treaty"] == 1 ,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_clan_id": userClanId,
    "name": name,
    "character_id": characterId,
    "is_signed_treaty" : isSigned
  };
}