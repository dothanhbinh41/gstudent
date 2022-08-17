// To parse this JSON data, do
//
//     final items = itemsFromJson(jsonString);

import 'dart:convert';

List<ItemInventory> itemsFromJson(String str) => List<ItemInventory>.from(json.decode(str).map((x) => ItemInventory.fromJson(x)));

String itemsToJson(List<ItemInventory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemInventory {
  ItemInventory({
    this.id,
    this.itemsId,
    this.userId,
    this.quantity,
    this.item,
  });

  int id;
  int itemsId;
  int userId;
  int quantity;
  Item item;

  factory ItemInventory.fromJson(Map<String, dynamic> json) => ItemInventory(
    id: json["id"],
    itemsId: json["items_id"],
    userId: json["user_id"],
    quantity: json["quantity"],
    item: Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "items_id": itemsId,
    "user_id": userId,
    "quantity": quantity,
    "item": item.toJson(),
  };
}

class Item {
  Item({
    this.id,
    this.name,
    this.description,
    this.avatar,
    this.price,
    this.category,
  });

  int id;
  String name;
  String description;
  String avatar;
  int price;
  int useFor;
  Category category;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    avatar: json["avatar"],
    price: json["price"],
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "avatar": avatar,
    "price": price,
    "use_for": useFor,
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
