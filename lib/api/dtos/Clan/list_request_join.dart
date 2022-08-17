import 'dart:convert';

ListRequestJoinData listRequestJoinDataFromJson(String str) => ListRequestJoinData.fromJson(json.decode(str));

String listRequestJoinDataToJson(ListRequestJoinData data) => json.encode(data.toJson());

class ListRequestJoinData {
  ListRequestJoinData({
    this.error,
    this.data,
  });

  bool error;
  List<UserRequestJoin> data;

  factory ListRequestJoinData.fromJson(Map<String, dynamic> json) => ListRequestJoinData(
    error: json["error"],
    data: List<UserRequestJoin>.from(json["data"].map((x) => UserRequestJoin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserRequestJoin {
  UserRequestJoin({
    this.id,
    this.name,
    this.email,
  });

  int id;
  String name;
  String email;

  factory UserRequestJoin.fromJson(Map<String, dynamic> json) => UserRequestJoin(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };
}
