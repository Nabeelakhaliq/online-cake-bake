// To parse this JSON data, do
//
//     final homeCategoriesModel = homeCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<HomeCategoriesModel> homeCategoriesModelFromJson(String str) => List<HomeCategoriesModel>.from(json.decode(str).map((x) => HomeCategoriesModel.fromJson(x)));

String homeCategoriesModelToJson(List<HomeCategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeCategoriesModel {
  HomeCategoriesModel({
    required this.name,
    required this.price,
    required this.image,
    required this.isFavourite,
    required this.isAdded,
  });

  String name;
  int price;
  String image;
  bool isFavourite;
  bool isAdded;

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) => HomeCategoriesModel(
    name: json["name"],
    price: json["price"],
    image: json["image"],
    isFavourite: json["isFavourite"],
    isAdded: json["isAdded"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "image": image,
    "isFavourite": isFavourite,
    "isAdded": isAdded,
  };
}
