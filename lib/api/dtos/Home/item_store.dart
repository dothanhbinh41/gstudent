// To parse this JSON data, do
//
//     final itemStore = itemStoreFromJson(jsonString);

import 'dart:convert';

List<ItemStore> itemStoreFromJson(String str) => List<ItemStore>.from(json.decode(str).map((x) => ItemStore.fromJson(x)));

String itemStoreToJson(List<ItemStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemStore {
  ItemStore({
    this.id,
    this.name,
    this.canSell,
    this.description,
    this.avatar,
    this.price,
    this.category,
  });

  int id;
  String name;
  int canSell;
  String description;
  String avatar;
  int price;
  Category category;

  factory ItemStore.fromJson(Map<String, dynamic> json) => ItemStore(
    id: json["id"],
    name: json["name"],
    canSell: json["can_sell"],
    description: json["description"],
    avatar: json["avatar"],
    price: json["price"],
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "can_sell": canSell,
    "description": description,
    "avatar": avatar,
    "price": price,
    "category": category.toJson(),
  };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
