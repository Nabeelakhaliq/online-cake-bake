import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';

import 'icon_widgets.dart';

class DecoratedContainerWidgets{
  DecoratedContainerWidgets._();

  static Widget decoratedIconTextContainer(String text, IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: AppColors.kAccentColor, spreadRadius: 1.5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconWidgets.customIcon(iconData, iconColor),
          const SizedBox(width: 10.0),
          Text(text)
        ],
      ),
    );
  }

}