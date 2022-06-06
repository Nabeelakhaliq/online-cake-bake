import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

Widget customButton(String text, double fontSize, FontWeight fontWeight,context) {
  return Container(
    height: 50.0,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: LinearGradient(
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          colors: [
            AppColors.kPrimaryOne.withOpacity(0.8),
            AppColors.kPrimaryTwo ,
          ],
          stops: const [
            0.0,
            0.6
          ]),
    ),
    child: customTextWidget(text, fontSize, AppColors.whiteColor, fontWeight) ,
  );
}

Widget darkGreyButton(String text, double fontSize, FontWeight fontWeight, context) {
  return Container(
    height: 50.0,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: const LinearGradient(
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          colors: [
            Colors.black54,
            Colors.black54,
          ],
          stops: [
            0.0,
            0.6
          ]),
    ),
    child: customTextWidget(text, fontSize, AppColors.whiteColor, fontWeight) ,
  );
}