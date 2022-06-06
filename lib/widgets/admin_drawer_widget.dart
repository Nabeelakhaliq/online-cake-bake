import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/add_category_screen.dart';
import 'package:online_cake_ordering/screens/admin/all_orders.dart';
import 'package:online_cake_ordering/screens/admin/new_add_product_screen.dart';
import 'package:online_cake_ordering/screens/admin/slider_image_uploading.dart';
import 'package:online_cake_ordering/screens/profile_page.dart';
import 'package:online_cake_ordering/screens/user/login_screen.dart';
import 'package:online_cake_ordering/screens/user/main_page.dart';
import 'package:online_cake_ordering/screens/user/update_profile.dart';
import 'package:wave_drawer/wave_drawer.dart';

class CustomAdminDrawer extends StatefulWidget {
  const CustomAdminDrawer({Key? key}) : super(key: key);

  @override
  _CustomAdminDrawerState createState() => _CustomAdminDrawerState();
}

class _CustomAdminDrawerState extends State<CustomAdminDrawer> {

  String? nameTitle = "Cake Bake (Online)";
  String? emailTitle = "Welcome to Online Cake Ordering";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WaveDrawer(
      backgroundColor: AppColors.kAccentColor,
      boundaryColor: AppColors.kAccentLightColor,
      boundaryWidth: 5.8,
      child: ListView(
        children: [
          InkWell(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  radius: 35,
                ),
                radius: 38,
                backgroundColor: AppColors.primaryAccentColor,
              ),
              accountName: Text(
                nameTitle!,
                style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              accountEmail: Text(
                emailTitle!,
                style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              decoration: const BoxDecoration(color: AppColors.kAccentColor),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if(isUserLoggedIn()) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage(isAdmin: true)));
              }
              else {
                Fluttertoast.showToast(msg: "Please login first!");
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: AppColors.whiteColor,
            ),
            title: const Text('Add Category',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w900)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCategory()));
            },
          ),
          const Divider(
            color: AppColors.kAccentLightColor,
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: AppColors.whiteColor,
            ),
            title: const Text('Add Product',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w900)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewAddProduct()));
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProduct()));
            },
          ),
          const Divider(
            color: AppColors.kAccentLightColor,
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: AppColors.whiteColor,
            ),
            title: const Text('Add a Deal',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w900)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadSlider()));
            },
          ),
          const Divider(
            color: AppColors.kAccentLightColor,
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_basket,
              color: AppColors.whiteColor,
            ),
            title: const Text('All Order',
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w900)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AllOrders()));
            },
          ),
          const Divider(
            color: AppColors.kAccentLightColor,
            height: 10.0,
          ),
          ListTile(
            leading: Icon(
              isUserLoggedIn() ? Icons.logout : Icons.login,
              color: AppColors.whiteColor,
            ),
            title: Text(
                isUserLoggedIn() ? 'Logout' : 'Sign In',
                style: const TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w900)),
            onTap: () {
              Navigator.of(context).pop();
              checkUser();
            },
          ),
        ],
      ),
    );
  }

  void getUserData() {

    debugPrint("isUserLoggedIn ${isUserLoggedIn()}");
    if(isUserLoggedIn()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      setState(() {
        emailTitle = firebaseUser?.email;
        if(firebaseUser!.displayName != null && firebaseUser.displayName!.isNotEmpty) {
          nameTitle = firebaseUser.displayName;
        }
      });
    }
  }

  void checkUser() {

    debugPrint("isUserLoggedIn ${isUserLoggedIn()}");
    if(isUserLoggedIn()) {
      _signOut();
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => const SignIn())//if you want to disable back feature set to false
      );
    }
  }

  _signOut() async {

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();

    Fluttertoast.showToast(msg: "Admin Logout Successfully...!");
    Navigator.of(context).pop();
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => MainPage(selectedIndex: 0)),
          (route) => false, //if you want to disable back feature set to false
    );
  }

  void goToUpdateProfile() {

    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if(firebaseUser != null) {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child(StringAssets.firebaseUsersData).child(firebaseUser.uid);
      String userName = "", userPhone = "", userEmail = "", userPassword = "";

      setState(() {
        databaseRef.once().then((value) {
          setState(() {
            userName = value.snapshot.child("userName").value.toString();
            userPhone = value.snapshot.child("userPhone").value.toString();
            userEmail = value.snapshot.child("userEmail").value.toString();
            userPassword = value.snapshot.child("userPassword").value.toString();
          });
        }).whenComplete(() {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateProfile(userName: userName, userEmail: userEmail, userPhone: userPhone, userPassword: userPassword)));
        });
      });
    }
    else {
      Fluttertoast.showToast(msg: "Please Login First!");
    }
  }

}
