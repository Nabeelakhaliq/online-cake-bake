import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class UserCartController extends GetxController {

  DatabaseReference dbUserCartReference = FirebaseDatabase.instance.ref().child(StringAssets.userCartData);
  List<ProductModel> userCartList = List.empty(growable: true);
  bool isCartLoading = false;
  double totalPrice = 0;

  fetchCartProducts(String userID) async {
    isCartLoading = true;

    if(totalPrice != 0) {
      totalPrice = 0;
    }

    if(userCartList.isNotEmpty) {
      userCartList.clear();
    }

    if(isUserLoggedIn()) {

      await dbUserCartReference.child(FirebaseAuth.instance.currentUser!.uid).once().then((value) {
        for (var element in value.snapshot.children) {
          final Map value = element.value as Map;
          ProductModel? userCart = ProductModel.fromMap(value);
          userCartList.add(userCart!);

          totalPrice += (double.parse(userCart.productPrice) * userCart.productStockQuantity);
        }

        isCartLoading = false;
        update();
      });
    }
    else{
      isCartLoading = false;
      update();
    }

    if(StringAssets.cartProductsList.isNotEmpty) {
      StringAssets.cartProductsList.clear();
    }

    StringAssets.cartProductsList.addAll(userCartList);
    debugPrint("StringAssets.cartProductsList ${StringAssets.cartProductsList.length}");
  }

}