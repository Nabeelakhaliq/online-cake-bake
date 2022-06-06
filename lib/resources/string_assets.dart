
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/models/custom_cart_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';

class StringAssets {
  StringAssets._();

  static TextEditingController searchFieldController = TextEditingController();

  static String firebaseUsersData = "Users_Data";
  static String firebaseAdminCredentials = "Admin_Credentials";
  static String mainCategories = "MainCategories";
  static String categoriesData = "Categories_Data";
  static String productsData = "Products_Data";
  static String slidersData = "Slider_Data";
  static String userCartData = "User_Cart";
  static String userOrdersDetails = "MyOrders";
  static String userCustomOrdersDetails = "MyCustomOrders";
  static String userOrderedProducts = "MyOrders_Products";
  static String userOrderedProductsDeliveryAddress = "MyOrders_DeliveryAddress";
  static String usersAddressesData = "Users_Addresses";
  static String categoryStorageReference = "Category_Images";
  static String productsStorageReference = "Products_Images";
  static String paymentSSStorageReference = "Payment_ScreenShots";
  static String sliderStorageReference = "Slider_Images";

  static String adminUsersCustomOrdersData = "Users_Custom_Orders";
  static String adminUsersOrdersData = "Users_Orders";
  static String adminUsersOrderedProductsData = "Users_OrderedProducts";
  static String adminUsersOrderDeliveryAddressData = "Users_OrderDeliveryAddress";

  static String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // region User Cart
  static AddressModel? addressModel;
  static List<ProductModel> cartProductsList = List.empty(growable: true);
  static CustomCartModel? customCartModel;
  static int noOfItems = 0;
  static double subTotal = 0.0;
  static double shippingFee = 99.99;
  static double totalPrice = 0.0;
  // endregion

}