
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:online_cake_ordering/models/cart_model.dart';
import 'package:online_cake_ordering/models/categories_model.dart';
import 'package:online_cake_ordering/models/home_categories_model.dart';

Future readHomeCategoryJSONData() async {

  List dataList;

  final String response = await rootBundle.loadString("assets/json/data.json");
  var data = await json.decode(response);

  List result = data["HomeCategories"] as List;

  if (kDebugMode) {
    debugPrint("result $result");
  }

  dataList = result.map<HomeCategoriesModel>((json) => HomeCategoriesModel.fromJson(json)).toList();

  return dataList;
}

Future readCategoriesJSONData() async {

  List dataList;

  final String response = await rootBundle.loadString("assets/json/data.json");
  var data = await json.decode(response);

  List result = data["CakeCategories"] as List;

  if (kDebugMode) {
    debugPrint("result $result");
  }

  dataList = result.map<CategoriesModel>((json) => CategoriesModel.fromJson(json)).toList();

  return dataList;
}

Future readCartJSONData() async {

  List dataList;

  final String response = await rootBundle.loadString("assets/json/data.json");
  var data = await json.decode(response);

  List result = data["UserCart"] as List;

  if (kDebugMode) {
    debugPrint("result $result");
  }

  dataList = result.map<CartModel>((json) => CartModel.fromJson(json)).toList();

  return dataList;
}