import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/models/slider_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class AdminHomeController extends GetxController {

  DatabaseReference dbProductsReference = FirebaseDatabase.instance.ref().child(StringAssets.productsData);
  DatabaseReference dbSlidersReference = FirebaseDatabase.instance.ref().child(StringAssets.slidersData);
  List<NewProductModel> productsList = List.empty(growable: true);
  List<SliderModel> slidersList = List.empty(growable: true);
  bool isProductsLoading = false;
  bool isSlidersLoading = false;
  List<String> imagesList = List.empty(growable: true);


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
  }

  fetchAllBanners() async {
    isSlidersLoading = true;

    if(imagesList.isNotEmpty) {
      imagesList.clear();
    }

    if(slidersList.isNotEmpty) {
      slidersList.clear();
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

    isSlidersLoading = false;
    update();
  }

}