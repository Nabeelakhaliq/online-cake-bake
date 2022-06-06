import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class FilteredProductsController extends GetxController {

  DatabaseReference dbMainCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.mainCategories);
  DatabaseReference dbProductsReference = FirebaseDatabase.instance.ref().child(StringAssets.productsData);
  List<NewProductModel> allProductsList = List.empty(growable: true);
  List<String> mainCategoriesList = List.empty(growable: true);
  bool allProductsLoading = false;
  RxBool isFilteredApplied = false.obs;

  late RangeValues currentRangeValuesPrice;
  late TextEditingController startPriceValueEditingController;
  late TextEditingController endPriceValueEditingController;

  late FocusNode startPriceValueFocusNode;
  late FocusNode endPriceValueFocusNode;

  String? selectedCategory;

  int maxPrice = 0;

  @override
  onInit() {
    // TODO: implement onInit
    super.onInit();

    startPriceValueEditingController = TextEditingController();
    endPriceValueEditingController = TextEditingController();

    startPriceValueFocusNode = FocusNode();
    endPriceValueFocusNode = FocusNode();

    initRangeValues();
  }

  fetchMainCategories() async {

    if(mainCategoriesList.isNotEmpty) {
      mainCategoriesList.clear();
    }

    selectedCategory = null;

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

  changeCategory(String value) async {

    selectedCategory = value;
    update();
  }

  initRangeValues() {
    maxPrice = 10000;
    currentRangeValuesPrice = RangeValues(0, maxPrice.toDouble());
    startPriceValueEditingController.text = 0.toString();
    endPriceValueEditingController.text = maxPrice.toString();

    update();
  }

  fetchAllProducts() async {
    allProductsLoading = true;

    if(allProductsList.isNotEmpty) {
      allProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? productModel = NewProductModel.fromMap(value);
        allProductsList.add(productModel!);
      }

      allProductsLoading = false;
      update();
    });
  }

  fetchFilteredProducts(double minPrice, double maxPrice) async {
    allProductsLoading = true;

    if(allProductsList.isNotEmpty) {
      allProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? productModel = NewProductModel.fromMap(value);

        if(double.parse(productModel!.productPrice) >= minPrice && double.parse(productModel.productPrice) <= maxPrice)
        {
          if(selectedCategory != null) {
            if(productModel.productMainCategory == selectedCategory) {
              allProductsList.add(productModel);
            }
          }
          else {
            allProductsList.add(productModel);
          }
        }
      }

      allProductsLoading = false;
      update();
    });
  }

  Future<void> setPrice(RangeValues selectedValue) async {
    currentRangeValuesPrice = selectedValue;
    await setRangeValues();
    update();
  }

  Future<bool> setRangeValues() async {
    startPriceValueEditingController.value = TextEditingValue(text: currentRangeValuesPrice.start.round().toString());
    endPriceValueEditingController.value = TextEditingValue(text: currentRangeValuesPrice.end.round().toString());

    return true;
  }

  void removeFocus() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await setRangeValues();
    update();
  }

  @override
  void onClose() {
    startPriceValueEditingController.dispose();
    endPriceValueEditingController.dispose();

    startPriceValueFocusNode.dispose();
    endPriceValueFocusNode.dispose();
    selectedCategory = null;

    super.onClose();
  }

}
