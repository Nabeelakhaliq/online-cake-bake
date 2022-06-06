import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class MyOrdersController extends GetxController {

  DatabaseReference dbMyOrdersRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrdersDetails);
  DatabaseReference dbOrderedProductsRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProducts);
  DatabaseReference dbDeliveryAddressRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProductsDeliveryAddress);
  List<ProductModel> orderedProductsList = List.empty(growable: true);
  late AddressModel orderDeliveryAddressModel;
  bool isOrdersLoading = false;
  bool isOrdersDetailsLoading = false;
  List<String> ordersTabList = List.empty(growable: true);
  int selectedIndex = 0;

  List<OrderModel> myOrdersList = List.empty(growable: true);
  List<OrderModel> pendingOrdersList = List.empty(growable: true);
  List<OrderModel> deliveredOrdersList = List.empty(growable: true);
  List<OrderModel> receivedOrdersList = List.empty(growable: true);

  @override
  void onInit() {
    // TODO: implement onInit

    if(ordersTabList.isNotEmpty){
      ordersTabList.clear();
    }

    ordersTabList.add("All");
    ordersTabList.add("Pending");
    ordersTabList.add("Delivered");
    ordersTabList.add("Received");

    super.onInit();
  }

  void setSelectTabIndex(int index){
    selectedIndex = index;
  }

  void selectTabIndex(int index){
    selectedIndex = index;
    update();
  }

  fetchMyOrders() async {

    isOrdersLoading = true;
    update();

    if(myOrdersList.isNotEmpty) {
      myOrdersList.clear();
    }
    if(pendingOrdersList.isNotEmpty) {
      pendingOrdersList.clear();
    }
    if(deliveredOrdersList.isNotEmpty) {
      deliveredOrdersList.clear();
    }
    if(receivedOrdersList.isNotEmpty) {
      receivedOrdersList.clear();
    }

    if(isUserLoggedIn()) {
      await dbMyOrdersRef.child(FirebaseAuth.instance.currentUser!.uid).once().then((value) {
        for (var element in value.snapshot.children) {
          final Map value = element.value as Map;
          OrderModel? orderModel = OrderModel.fromMap(value);
          myOrdersList.add(orderModel!);

          if(orderModel.orderStatus == "Pending") {
            pendingOrdersList.add(orderModel);
          }
          if(orderModel.orderStatus == "Delivered") {
            deliveredOrdersList.add(orderModel);
          }
          if(orderModel.orderStatus == "Received") {
            receivedOrdersList.add(orderModel);
          }
          debugPrint("orderModel : ${orderModel.toJson()}");
        }
      });
    }

    isOrdersLoading = false;
    update();
  }

  fetchOrderDetails(String orderedProductsID, String ordDeliveryAddressID) async {

    isOrdersDetailsLoading = true;

    if(orderedProductsList.isNotEmpty) {
      orderedProductsList.clear();
    }

    await dbOrderedProductsRef.child(FirebaseAuth.instance.currentUser!.uid).child(orderedProductsID).once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        ProductModel? productModel = ProductModel.fromMap(value);
        orderedProductsList.add(productModel!);
        debugPrint("productModel : ${productModel.toJson()}");
      }
    });

    fetchOrderDeliveryDetails(ordDeliveryAddressID);

    debugPrint("orderedProductsList : ${orderedProductsList.length}");
    isOrdersDetailsLoading = false;
    update();
  }

  fetchOrderDeliveryDetails(String ordDeliveryAddressID) async {

    await dbDeliveryAddressRef.child(FirebaseAuth.instance.currentUser!.uid).child(ordDeliveryAddressID).once().then((value) {
      final Map val = value.snapshot.value as Map;
      AddressModel? addressModel = AddressModel.fromMap(val);
      orderDeliveryAddressModel = addressModel!;
      debugPrint("orderDeliveryAddressModel : ${orderDeliveryAddressModel.toJson()}");
    });
  }

}