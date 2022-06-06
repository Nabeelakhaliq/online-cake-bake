// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) => List<CategoriesModel>.from(json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  CategoriesModel({
    required this.name,
    required this.image,
    required this.items,
  });

  String name;
  String image;
  List<CategoryItems> items;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    name: json["name"],
    image: json["image"],
    items: List<CategoryItems>.from(json["items"].map((x) => CategoryItems.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class CategoryItems {
  CategoryItems({
    required this.title,
    required this.details,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.type,
  });

  String title;
  String details;
  String imageUrl;
  int price;
  double rating;
  String type;

  factory CategoryItems.fromJson(Map<String, dynamic> json) => CategoryItems(
    title: json["title"],
    details: json["details"],
    imageUrl: json["imageUrl"],
    price: json["price"],
    rating: json["rating"].toDouble(),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "details": details,
    "imageUrl": imageUrl,
    "price": price,
    "rating": rating,
    "type": type,
  };
}