//region common input decoration
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/app_styles.dart';

InputDecoration myInputDecoration(String label, String hint, bool isIcon, Widget icon, bool dense, EdgeInsetsGeometry contentPadding){
  return InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.darkGreyColor,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.kAccentColor,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.kAccentColor,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.darkGreyColor,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.lightGreyColor,
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: AppColors.darkGreyColor,
        ),
      ),
      isDense: dense,
      contentPadding: contentPadding,
      labelText: label,
      labelStyle: AppStyles.labelTextStyle,
      alignLabelWithHint: true,
      hintText: hint,
      hintStyle: AppStyles.hintTextStyle,
      counter: const Offstage(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: isIcon ? icon : null
  );
}
//endregion