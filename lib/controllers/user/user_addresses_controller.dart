import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class UserAddressesController extends GetxController {

  DatabaseReference dbUserAddressReference = FirebaseDatabase.instance.ref().child(StringAssets.usersAddressesData);
  List<AddressModel> userAddressesList = List.empty(growable: true);
  bool isAddressesLoading = false;

  fetchUserAddresses() async {
    isAddressesLoading = true;

    if(userAddressesList.isNotEmpty) {
      userAddressesList.clear();
    }

    if(isUserLoggedIn()) {
      await dbUserAddressReference.child(FirebaseAuth.instance.currentUser!.uid).once().then((value) {
        for (var element in value.snapshot.children) {
          final Map value = element.value as Map;
          AddressModel? userAddress = AddressModel.fromMap(value);
          userAddressesList.add(userAddress!);

          if(userAddress.isDefaultShippingAddress) {
            StringAssets.addressModel = userAddress;
          }
        }

        isAddressesLoading = false;
        update();
      });
    }
    else {
      isAddressesLoading = false;
      update();
    }

    debugPrint("StringAssets.addressModel ${StringAssets.addressModel}");
  }

}