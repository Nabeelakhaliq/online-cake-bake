import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWidgets {
  IconWidgets._();

  static Widget customIcon(IconData iconData, Color iconColor) {
    return Icon(iconData, color: iconColor);
  }

  static Widget sizedIcon(IconData iconData, Color iconColor, double _size) {
    return Icon(iconData, color: iconColor, size: _size);
  }

}