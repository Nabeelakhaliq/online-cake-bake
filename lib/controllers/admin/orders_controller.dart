import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class OrdersController extends GetxController {

  DatabaseReference dbUserOrderRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrdersDetails);
  DatabaseReference dbAllOrdersRef = FirebaseDatabase.instance.ref().child(StringAssets.adminUsersOrdersData);
  DatabaseReference dbOrderedProductsRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProducts);
  DatabaseReference dbDeliveryAddressRef = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProductsDeliveryAddress);
  List<ProductModel> orderedProductsList = List.empty(growable: true);
  late AddressModel orderDeliveryAddressModel;
  bool isOrdersLoading = false;
  bool isOrdersDetailsLoading = false;
  List<String> ordersTabList = List.empty(growable: true);
  int selectedIndex = 0;

  List<OrderModel> allOrdersList = List.empty(growable: true);
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

  fetchAllOrders() async {
    isOrdersLoading = true;
    update();

    if(allOrdersList.isNotEmpty) {
      allOrdersList.clear();
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

    await dbAllOrdersRef.once().then((value) {
      for (var element in value.snapshot.children) {
        Map value = element.value as Map;
        OrderModel? orderModel = OrderModel.fromMap(value);
        allOrdersList.add(orderModel!);

        if(orderModel.orderStatus == "Pending") {
          pendingOrdersList.add(orderModel);
        }
        if(orderModel.orderStatus == "Delivered") {
          deliveredOrdersList.add(orderModel);
        }
        if(orderModel.orderStatus == "Received") {
          receivedOrdersList.add(orderModel);
        }
      }
    });

    isOrdersLoading = false;
    update();
  }

  updateOrderStatus(context, String customerID, String orderID, String orderStatus) async {

    Map<String, Object> newStatusVal = HashMap();
    newStatusVal['orderStatus'] = orderStatus;
    await dbAllOrdersRef.child(orderID).update(newStatusVal).whenComplete(() {
      dbUserOrderRef.child(customerID).child(orderID).update(newStatusVal).whenComplete(() {
        Fluttertoast.showToast(msg: "Status Updated successfully...!");
        fetchUpdatedAllOrders();
      });
    });

    Navigator.of(context).pop();
  }

  fetchUpdatedAllOrders() async {

    if(allOrdersList.isNotEmpty) {
      allOrdersList.clear();
    }

    await dbAllOrdersRef.once().then((value) {
      for (var element in value.snapshot.children) {
        Map value = element.value as Map;
        OrderModel? orderModel = OrderModel.fromMap(value);
        allOrdersList.add(orderModel!);
      }
    });

    update();
  }

}