import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/payment_method.dart';
import 'package:online_cake_ordering/screens/user/saved_addresses.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

class ShippingAddressSelection extends StatefulWidget {

  const ShippingAddressSelection({Key? key}) : super(key: key);

  @override
  _ShippingAddressSelectionState createState() => _ShippingAddressSelectionState();
}

class _ShippingAddressSelectionState extends State<ShippingAddressSelection> {

  bool isChecked = true;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      appBar: customAppBar("Shipping Address"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: IconTextButton(
                      text: 'Select Shipping Address',
                      fontSize: 16.0,
                      backgroundColor: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      iconData: Icons.add,
                      iconSize: 40.0,
                      alignment: MainAxisAlignment.center,
                      onPress: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SavedAddresses(isSelectable: true, type: 1)));
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black12,
                    height: 5,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.shop, color: AppColors.kAccentColor),
                          ),
                          customTextWidget("Package ${StringAssets.noOfItems} of ${StringAssets.noOfItems}", 14.0, AppColors.kAccentColor, FontWeight.normal)
                        ],
                      ),
                      Row(
                        children: [
                          customTextWidget("Shipped By ", 14.0, AppColors.kAccentColor, FontWeight.normal),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: customTextWidget("Faisal Arshad", 12.0, AppColors.blackColor, FontWeight.normal),
                          )
                        ],
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 1.5,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black12,
                    height: 5,
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: StringAssets.addressModel != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: customTextWidget("Delivery Option", 18.0, Colors.black, FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(color: Colors.black12),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.receipt, color: AppColors.kAccentColor),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: customTextWidget("Rs. ${StringAssets.shippingFee}", 16.0, AppColors.kAccentColor, FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
                                    indent: 0.0,
                                    endIndent: 0.0,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          customTextWidget(StringAssets.addressModel != null ? "${StringAssets.addressModel!.addressType} Delivery" : "Home Delivery", 16.0, Colors.black, FontWeight.w600),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 5.0),
                                            child: myTextWidget(StringAssets.addressModel != null ? StringAssets.addressModel!.deliveryAddress : "COMSATS University Islamabad, Vehari", const TextStyle(fontSize: 12.0, color: Colors.black), 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all<Color>(AppColors.kAccentColor),
                                    value: isChecked,
                                    //shape: CircleBorder(),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: customTextWidget("Products", 18.0, Colors.black, FontWeight.bold),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: StringAssets.cartProductsList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (bContext, index) {
                  ProductModel cartModel = StringAssets.cartProductsList[index];
                  return buildCartItems(cartModel);
            }),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextWidget("Subtotal (${StringAssets.noOfItems} items)", 16.0, Colors.black, FontWeight.normal),
                        customTextWidget("Rs. ${StringAssets.subTotal}", 16.0, Colors.black, FontWeight.bold)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextWidget("Shipping Fee", 16.0, Colors.black, FontWeight.normal),
                        customTextWidget("Rs. ${StringAssets.shippingFee}", 16.0, Colors.black, FontWeight.bold)
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: customTextWidget("Total : Rs. ${StringAssets.totalPrice}", 16.0, AppColors.kAccentColor, FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(10),
          horizontal: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: getProportionateScreenWidth(190),
            child: DefIconTextButton(
              text: 'Proceed to Pay',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              iconData: Icons.payment,
              onPress: () {
                if(StringAssets.addressModel == null) {
                  Fluttertoast.showToast(msg: "Please select shipping address!");
                }
                else if(!isChecked) {
                  Fluttertoast.showToast(msg: "Please check the shipping address!");
                }
                else if (StringAssets.addressModel != null && isChecked) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentMethod()));
                }
                else {
                  Fluttertoast.showToast(msg: "Please select shipping address!");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCartItems(ProductModel cartModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(color: AppColors.whiteColor, spreadRadius: 1.5),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 120.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(cartModel.productImage),
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                color: Colors.redAccent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: customTextWidget(cartModel.productName, 15.0, Colors.black, FontWeight.bold),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: myTextWidget("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore", const TextStyle(
                          color: Colors.black), 2
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customTextWidget("Rs. ${cartModel.productPrice}", 18.0, AppColors.kAccentColor, FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: alignedTextWidget("item: 1", const TextStyle(color: AppColors.blackColor, fontSize: 14.0), 1, TextAlign.start),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                            child: alignedTextWidget("Qty: ${cartModel.productStockQuantity}", const TextStyle(color: AppColors.blackColor, fontSize: 14.0), 1, TextAlign.start),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
