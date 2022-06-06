import 'package:online_cake_ordering/models/users_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/update_admin_profile.dart';
import 'package:online_cake_ordering/screens/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.isAdmin}) : super(key: key);
  final bool isAdmin;

  @override
  _ProfilePageState createState() => _ProfilePageState(isAdmin);
}

class _ProfilePageState extends State<ProfilePage> {

  _ProfilePageState(this.isAdmin);

  final bool isAdmin;
  late DatabaseReference databaseRef;
  User? firebaseUser;
  late String? userEmail;
  late String? userName;
  late String? userPhone;
  late String? userPassword;
  late String? userCity;
  late String? userAddress;
  bool callForgetUserData = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    userEmail = "test.123@gmail.com";
    userName = "Test Name";
    userPhone = "03008723456";
    userCity = "Vehari";
    userAddress = "COMSATS University Islamabad, Vehari";

    callForgetUserData = true;

    if(isAdmin) {
      getAdminData();
    }
    else {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Profile"),
      backgroundColor: AppColors.whiteColor,
      body: ModalProgressHUD(
        inAsyncCall: callForgetUserData,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.kAccentColor),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 60.0),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            color: AppColors.profileColor
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    userName!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.kAccentColor
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 100.0,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.kAccentColor
                                ),
                                child: Image.network(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                    height: 100.0, width: 100.0),
                              ),
                              Positioned(
                                  right: -30.0,
                                  bottom: 5.0,
                                  child: MaterialButton(
                                    //minWidth: 0,
                                    color: AppColors.kAccentColor,
                                    textColor: AppColors.kAccentColor,
                                    child: const Icon(
                                      Icons.camera,
                                      size: 24,
                                      color: AppColors.whiteColor,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    shape: const CircleBorder(),
                                    onPressed: () {},
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: const Text(
                                "Personal Details",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      profileMenuWidget(
                          context,
                          "User Name",
                          userName!
                      ),
                      profileMenuWidget(
                          context,
                          "Email",
                          userEmail!
                      ),
                      profileMenuWidget(
                          context,
                          "Phone Number",
                          userPhone!
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: !isAdmin,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: const Text(
                                  "Address Details",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        profileMenuWidget(
                            context,
                            "User City",
                            userCity!
                        ),
                        profileMenuWidget(
                            context,
                            "Address",
                            userAddress!
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: MaterialButton(
                onPressed: (){
                  if(isAdmin) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UpdateAdminProfile(userName: userName!, userEmail: userEmail!, userPhone: userPhone!, userPassword: userPassword!)));
                  }
                  else {
                    Users user = Users(userName!, userEmail!, userPhone!, userPassword!, userCity!, userAddress!);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UpdateProfile(userData: user)));
                  }
                },
                minWidth: 0,
                color: AppColors.kAccentColor,
                textColor: AppColors.whiteColor,
                child: const Icon(
                  Icons.edit,
                  size: 24,
                  color: AppColors.whiteColor,
                ),
                padding: const EdgeInsets.all(8),
                shape: const CircleBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserData() async {

    firebaseUser = FirebaseAuth.instance.currentUser;
    databaseRef = FirebaseDatabase.instance.ref().child(StringAssets.firebaseUsersData).child(firebaseUser!.uid);

    setState(() {
      databaseRef.once().then((value) {
        setState(() {
          userName = value.snapshot.child("userName").value.toString();
          userPhone = value.snapshot.child("userPhone").value.toString();
          userEmail = value.snapshot.child("userEmail").value.toString();
          userPassword = value.snapshot.child("userPassword").value.toString();
          userCity = value.snapshot.child("userCity").value.toString();
          userAddress = value.snapshot.child("userAddress").value.toString();

          callForgetUserData = false;
        });
      });
    });
  }

  void getAdminData() async {

    firebaseUser = FirebaseAuth.instance.currentUser;
    databaseRef = FirebaseDatabase.instance.ref().child(StringAssets.firebaseAdminCredentials).child(firebaseUser!.uid);

    setState(() {
      databaseRef.once().then((value) {
        setState(() {
          userName = value.snapshot.child("adminName").value.toString();
          userPhone = value.snapshot.child("adminPhone").value.toString();
          userEmail = value.snapshot.child("adminEmail").value.toString();
          userPassword = value.snapshot.child("adminPassword").value.toString();

          callForgetUserData = false;
        });
      });
    });
  }

  //region profile menu widget
  Widget profileMenuWidget(BuildContext context, String text, String textValue) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: AppColors.profileColor
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(text,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16.0, color: AppColors.blackColor, fontWeight: FontWeight.normal))
                )
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(textValue,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16.0, color: AppColors.kAccentColor, fontWeight: FontWeight.normal))
                )
              ],
            ),
          ]),
    );
  }
  //endregion

}