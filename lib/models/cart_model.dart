// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  String name;
  String imageUrl;
  double price;
  int quantity;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    name: json["name"],
    imageUrl: json["imageUrl"],
    price: json["price"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageUrl": imageUrl,
    "price": price,
    "quantity": quantity,
  };
}
