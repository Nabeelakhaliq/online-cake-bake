import 'package:flutter/material.dart';
import 'package:online_cake_ordering/generated/assets.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/main_page.dart';
import 'package:online_cake_ordering/widgets/button_widgets.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/image_widgets.dart';

class OrderConfirmation extends StatefulWidget {

  const OrderConfirmation({Key? key, required this.paymentMethod, required this.isSuccess}) : super(key: key);
  final String paymentMethod;
  final bool isSuccess;

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState(paymentMethod: paymentMethod, isSuccess: isSuccess);
}

class _OrderConfirmationState extends State<OrderConfirmation> {

  _OrderConfirmationState({required this.paymentMethod, required this.isSuccess});
  final String paymentMethod;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            MainPage(selectedIndex: 0)), (Route<dynamic> route) => false);

        return true;
      },
      child: Scaffold(
        appBar: customAppBar(paymentMethod),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: customImageWidgets(paymentMethod == "Cash on Delivery" ? Assets.imagesPaymentSuccess : Assets.imagesPaymentFailed),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: customTextWidget("Order Successful", 18.0, AppColors.blackColor, FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: customTextWidget("Order has been placed successfully.", 14.0, AppColors.grey, FontWeight.normal),
              ),
              Visibility(
                visible: paymentMethod == "Cash on Delivery" ? true : false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: customButton("Okay", 18.0, FontWeight.bold, context),
                        ),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              MainPage(selectedIndex: 0)), (Route<dynamic> route) => false);
                        },
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: darkGreyButton("Not Now", 18.0, FontWeight.bold, context),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}