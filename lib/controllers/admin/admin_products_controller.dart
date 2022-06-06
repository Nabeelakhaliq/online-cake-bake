import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class AdminProductsController extends GetxController {

  DatabaseReference dbMainCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.mainCategories);
  DatabaseReference dbCakeCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.categoriesData);
  List<String> mainCategoriesList = List.empty(growable: true);
  List<CategoryModel> cakeCategoriesList = List.empty(growable: true);
  CategoryModel? selectedCakeCategory;
  bool isCakeCategoriesLoading = false;

  fetchMainCategories() async {

    if(mainCategoriesList.isNotEmpty) {
      mainCategoriesList.clear();
    }

    await dbMainCategoriesReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        mainCategoriesList.add(value["productMainCategory"]);
        debugPrint(value["productMainCategory"]);
        debugPrint(value.toString());
      }

      update();
    });
  }

  fetchCakeCategories() async {
    isCakeCategoriesLoading = true;

    if(cakeCategoriesList.isNotEmpty) {
      cakeCategoriesList.clear();
    }

    selectedCakeCategory = null;

    await dbCakeCategoriesReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        CategoryModel? dataModel = CategoryModel.fromMap(value);
        cakeCategoriesList.add(dataModel!);
      }

      isCakeCategoriesLoading = false;
      update();
    });
  }

  changeCakeCategory(CategoryModel value) async {

    selectedCakeCategory = value;
    update();
  }

}