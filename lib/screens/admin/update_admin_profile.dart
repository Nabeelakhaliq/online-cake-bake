import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:online_cake_ordering/models/admin_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/main_page.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

class UpdateAdminProfile extends StatefulWidget {
  const UpdateAdminProfile({Key? key, required this.userName, required this.userEmail, required this.userPhone, required this.userPassword}) : super(key: key);

  final String userName;
  final String userEmail;
  final String userPhone;
  final String userPassword;

  @override
  _UpdateAdminProfileState createState() => _UpdateAdminProfileState(userEmail: userEmail, userName: userName, userPhone: userPhone, userPassword: userPassword);
}

class _UpdateAdminProfileState extends State<UpdateAdminProfile> {

  final String userName;
  final String userEmail;
  final String userPhone;
  final String userPassword;

  _UpdateAdminProfileState(
      {required this.userName, required this.userEmail, required this.userPhone, required this.userPassword});

  late DatabaseReference databaseRef;
  User? firebaseUser;
  late String message;
  bool _success = false;
  bool isFormValidated = false;
  bool callForUpdateProfile = false;

  TextEditingController adminNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _updateProfileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    adminNameController.text = userName;
    emailController.text = userEmail;
    phoneController.text = userPhone;
    firebaseUser = FirebaseAuth.instance.currentUser;
    databaseRef = FirebaseDatabase.instance.ref().child(
        StringAssets.firebaseAdminCredentials);
    message = "";
    callForUpdateProfile = false;
    isFormValidated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: callForUpdateProfile,
          progressIndicator: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.kAccentColor),
          ),
          child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    ImageAssets.imagesSignBgImage,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.18),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(55),
                            topLeft: Radius.circular(55),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(55),
                            topLeft: Radius.circular(55),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Update Admin Profile",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.060,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Form(
                                    key: _updateProfileFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          FormFieldsWidgets.headingFormField(
                                              context, "Admin Email"),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          EmailFormField(
                                              emailController: emailController,
                                              isEditable: false),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FormFieldsWidgets.headingFormField(
                                              context, "Admin New Name"),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          NameFormField(
                                              nameController: adminNameController),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FormFieldsWidgets.headingFormField(
                                              context, "Admin New Phone Number"),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          FormFieldsWidgets.mobileFormField(
                                              phoneController, context),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Builder(
                                      builder: (ctx) =>
                                          DefaultButton(
                                            text: "Update Profile",
                                            onPress: () async {
                                              await _updateUserData();

                                              if (message != "") {
                                                setState(() {
                                                  callForUpdateProfile = false;
                                                });
                                              }

                                              if (message != "") {
                                                if (_success == true) {
                                                  Fluttertoast.showToast(
                                                      msg: message);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => MainPage(selectedIndex: 0)));
                                                }
                                                else {
                                                  Fluttertoast.showToast(
                                                      msg: message);
                                                }
                                              }
                                            },
                                          )
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                          ),
                        )),
                  ),
                ],
              )
          ),
        )
    );
  }

  Future<void> _updateUserData() async {
    if (_updateProfileFormKey.currentState!.validate()) {
      setState(() {
        isFormValidated = true;
        callForUpdateProfile = true;
      });

      Admin adminModel = Admin(
          adminNameController.text, emailController.text, phoneController.text,
          userPassword);
      databaseRef.child(firebaseUser!.uid)
          .set(adminModel.toJson())
          .whenComplete(() async {

        message = "Profile Updated Successfully....!";
        _success = true;
        debugPrint(message);
      }).then((_) {
        message = "Profile Updated Successfully....!";
        _success = true;
        debugPrint(message);
      }).onError((error, stackTrace) {
        message = "Error while Updating Profile..!";
        _success = false;
        debugPrint(error.toString());
        debugPrint(message);
      });
    }

    setState(() {
      message = "Profile Updated Successfully....!";
      _success = true;
    });

    if(_success == true) {
      await firebaseUser!.updateDisplayName(adminNameController.text);
      await firebaseUser!.updateEmail(emailController.text);
      //await firebaseUser!.updatePassword(userPassword);
    }
    debugPrint("message $message");
  }
  
}