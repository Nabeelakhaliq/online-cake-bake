import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/font_family.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_home.dart';
import 'package:splashscreen/splashscreen.dart';
import '../user/main_page.dart';

class MySplashScreen extends StatefulWidget {

  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: navigateToNext(),
      //navigateAfterSeconds: const MainPage(),
      title: const Text(
        "Cake Bake (Online)",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 38.0,
            color: AppColors.primaryColor,
            letterSpacing: 2.5,
            fontFamily: FontFamily.signatra
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(ImageAssets.imagesLogoIcon),
      backgroundColor: Colors.white,
      photoSize: 150,
      useLoader: true,
      loaderColor: AppColors.primaryAccentColor,
      loadingText: const Text(
        "COMSATS University Islamabad, Vehari",
        style: TextStyle(
            fontSize: 20.0,
            color: AppColors.primaryColor,
            fontFamily: FontFamily.brandBold
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  dynamic navigateToNext() {

    if(isUserLoggedIn()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if(firebaseUser!.email == "admin.123@gmail.com") {
        return const AdminHome();
      }
      else {
        return MainPage(selectedIndex: 0);
      }
    }
    else {
      return MainPage(selectedIndex: 0);
    }
  }

}
