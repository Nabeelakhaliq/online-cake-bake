import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/models/slider_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class UserProductsController extends GetxController {

  DatabaseReference dbSlidersReference = FirebaseDatabase.instance.ref().child(StringAssets.slidersData);
  DatabaseReference dbProductsReference = FirebaseDatabase.instance.ref().child(StringAssets.productsData);
  DatabaseReference dbMainCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.mainCategories);
  DatabaseReference dbCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.categoriesData);

  List<String> mainCategoriesList = List.empty(growable: true);
  List<CategoryModel> cakeCategoriesList = List.empty(growable: true);
  List<NewProductModel> productsList = List.empty(growable: true);
  List<NewProductModel> categoryProductsList = List.empty(growable: true);
  List<NewProductModel> cakeCategoryProductsList = List.empty(growable: true);
  List<NewProductModel> featuredProductsList = List.empty(growable: true);
  List<NewProductModel> recommendedProductsList = List.empty(growable: true);
  List<SliderModel> slidersList = List.empty(growable: true);
  List<String> imagesList = List.empty(growable: true);

  bool isMainCategoriesLoading = false;
  bool isCakeCategoriesLoading = false;
  bool isProductsLoading = false;
  bool isCategoryProductsLoading = false;
  bool isCakeCategoryProductsLoading = false;
  bool isFeaturedProductsLoading = false;
  bool isRecommendedProductsLoading = false;
  bool isSlidersLoading = false;

  int selectedCategory = 0;

  fetchAllBanners() async {
    isSlidersLoading = true;

    if(slidersList.isNotEmpty) {
      slidersList.clear();
    }

    if(imagesList.isNotEmpty) {
      imagesList.clear();
    }

    await dbSlidersReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        SliderModel? sliderModel = SliderModel.fromMap(value);
        slidersList.add(sliderModel!);
      }
    });

    if(slidersList.isNotEmpty) {
      for(var element in slidersList) {
        imagesList.add(element.sliderImage);
      }
    }

    debugPrint("imagesList ${imagesList.length}");

    isSlidersLoading = false;
    update();
  }

  fetchMainCategories() async {
    isMainCategoriesLoading = true;

    if(mainCategoriesList.isNotEmpty) {
      mainCategoriesList.clear();
    }

    await dbMainCategoriesReference.once().then((value) {
      for (var element in value.snapshot.children)
      {
        final Map value = element.value as Map;
        mainCategoriesList.add(value["productMainCategory"]);
        debugPrint(value["productMainCategory"]);
        debugPrint(value.toString());
      }

      isMainCategoriesLoading = false;
      update();
    });

    if(mainCategoriesList.isNotEmpty) {
      selectedCategory = 0;
      fetchCategoryAllProducts(mainCategoriesList[0]);
    }
  }

  fetchCakeCategories() async {
    isCakeCategoriesLoading = true;

    if(cakeCategoriesList.isNotEmpty) {
      cakeCategoriesList.clear();
    }

    await dbCategoriesReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        CategoryModel? dataModel = CategoryModel.fromMap(value);
        cakeCategoriesList.add(dataModel!);
      }

      isCakeCategoriesLoading = false;
      update();
    });

    debugPrint("cakeCategoriesList ${cakeCategoriesList.length}");
  }

  fetchAllProducts() async {
    isProductsLoading = true;

    if(productsList.isNotEmpty) {
      productsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? newProductModel = NewProductModel.fromMap(value);
        productsList.add(newProductModel!);
      }

      isProductsLoading = false;
      update();
    });

    debugPrint("productsList ${productsList.length}");
  }

  fetchCakeCategoryAllProducts(String cakeCategoryName) async {
    isCakeCategoryProductsLoading = true;
    // update();

    if(cakeCategoryProductsList.isNotEmpty) {
      cakeCategoryProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? productModel = NewProductModel.fromMap(value);

        if(productModel!.productSubCategory == cakeCategoryName) {
          cakeCategoryProductsList.add(productModel);
        }
      }

      isCakeCategoryProductsLoading = false;
      update();
    });

    debugPrint("cakeCategoryProductsList ${cakeCategoryProductsList.length}");
  }

  fetchCategoryAllProducts(String categoryName) async {
    isCategoryProductsLoading = true;
    update();

    if(categoryProductsList.isNotEmpty) {
      categoryProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? productModel = NewProductModel.fromMap(value);

        if(productModel!.productMainCategory == categoryName) {
          categoryProductsList.add(productModel);
        }
      }

      isCategoryProductsLoading = false;
      update();
    });

    debugPrint("categoryProductsList ${categoryProductsList.length}");
  }

  fetchAllFeaturedProducts() async {
    isFeaturedProductsLoading = true;

    if(featuredProductsList.isNotEmpty) {
      featuredProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? newProductModel = NewProductModel.fromMap(value);
        if(newProductModel!.isFeatured) {
          featuredProductsList.add(newProductModel);
        }
      }

      isFeaturedProductsLoading = false;
      update();
    });

    debugPrint("featuredProductsList ${featuredProductsList.length}");
  }

  fetchAllRecommendedProducts() async {
    isRecommendedProductsLoading = true;

    if(recommendedProductsList.isNotEmpty) {
      recommendedProductsList.clear();
    }

    await dbProductsReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        NewProductModel? productModel = NewProductModel.fromMap(value);

        if(productModel!.isRecommended) {
          recommendedProductsList.add(productModel);
        }
      }

      isRecommendedProductsLoading = false;
      update();
    });

    debugPrint("recommendedProductsList ${recommendedProductsList.length}");
  }

  changeSelectedCategory(int index) {
    selectedCategory = index;
    fetchCategoryAllProducts(mainCategoriesList[index]);
    update();
  }

}