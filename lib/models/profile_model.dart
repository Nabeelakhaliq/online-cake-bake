import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<UserProfile> getUserOptions() {

  List<UserProfile> optionList = [];

  optionList.add(UserProfile(
      "Settings",
      const Icon(
        CupertinoIcons.settings_solid,
        size: 30,
      )));
  optionList.add(UserProfile(
      "Payment",
      const Icon(
        Icons.payment,
        size: 35,
      )));
  optionList.add(UserProfile(
      "Notifications",
      const Icon(
        CupertinoIcons.bell,
        size: 35,
      )));
  optionList.add(UserProfile(
      "Support",
      const Icon(
        CupertinoIcons.info,
        size: 35,
      )));
  optionList.add(UserProfile(
      "Sign out",
      const Icon(
        Icons.logout,
        size: 35,
        color: Colors.red,
      )));

  return optionList;
}

class UserProfile {
  String title;
  Icon icon;

  UserProfile(this.title, this.icon);
}