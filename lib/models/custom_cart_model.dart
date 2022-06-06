// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

List<CustomCartModel> cartModelFromJson(String str) => List<CustomCartModel>.from(json.decode(str).map((x) => CustomCartModel.fromJson(x)));

String cartModelToJson(List<CustomCartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomCartModel {
  CustomCartModel({
    required this.name,
    required this.cakeSize,
    required this.cakeFlavour,
    required this.cakeEvent,
    required this.cakeIngredients,
    required this.price,
    required this.quantity
  });

  String name;
  String cakeSize;
  String cakeFlavour;
  String cakeEvent;
  String cakeIngredients;
  double price;
  int quantity;

  factory CustomCartModel.fromJson(Map<String, dynamic> json) => CustomCartModel(
    name: json["name"],
    cakeSize: json["cakeSize"],
    cakeFlavour: json["cakeFlavour"],
    cakeEvent: json["cakeEvent"],
    cakeIngredients: json["cakeIngredients"],
    price: json["price"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "cakeSize": cakeSize,
    "cakeFlavour": cakeFlavour,
    "cakeEvent": cakeEvent,
    "cakeIngredients": cakeIngredients,
    "price": price,
    "quantity": quantity,
  };
}
