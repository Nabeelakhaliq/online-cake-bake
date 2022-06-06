import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:online_cake_ordering/models/users_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_login.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

import '../user/login_screen.dart';
import '../user/main_page.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late DatabaseReference databaseReference;
  late String message;
  bool _success = false;
  bool isFormValidated = false;
  bool callForRegistration = false;
  late String userName;
  late String emailAddress;
  late String setPassword;
  late String phoneNumber;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController setPasswordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    databaseReference =
        FirebaseDatabase.instance.ref().child(StringAssets.firebaseUsersData);
    message = "";
    callForRegistration = false;
    isFormValidated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: callForRegistration,
          progressIndicator: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
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
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.18),
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
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Authorization",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.060,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SmallButton(
                                      text: "Admin",
                                      color: AppColors.lightGrey,
                                      textColor: AppColors.blackColor,
                                      onPress: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const AdminLogin()),
                                            (Route<dynamic> route) => false);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SmallButton(
                                      text: "Sign up",
                                      color: AppColors.primaryColor,
                                      textColor: AppColors.whiteColor,
                                      onPress: () {},
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SmallButton(
                                      text: "Sign in",
                                      color: AppColors.lightGrey,
                                      textColor: AppColors.blackColor,
                                      onPress: () {
                                        //Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (Route<dynamic> route) => false);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const SignIn()),
                                            (Route<dynamic> route) => false);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Form(
                                key: _signUpFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FormFieldsWidgets.headingFormField(
                                          context, "Full Name"),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      NameFormField(
                                          nameController: userNameController),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FormFieldsWidgets.headingFormField(
                                          context, "Email Address"),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      EmailFormField(
                                          emailController: emailController,
                                          isEditable: true),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FormFieldsWidgets.headingFormField(
                                          context, "Mobile Number"),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      FormFieldsWidgets.mobileFormField(
                                          mobileNumberController, context),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FormFieldsWidgets.headingFormField(
                                          context, "Password"),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      PasswordFormField(
                                          passwordController:
                                              setPasswordController),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Builder(
                                  builder: (ctx) => DefaultButton(
                                        text: "Create Account",
                                        onPress: () async {
                                          await _registerUser();

                                          if (message != "") {
                                            setState(() {
                                              callForRegistration = false;
                                            });
                                          }

                                          if (message != "") {
                                            if (_success == true) {
                                              Fluttertoast.showToast(
                                                  msg: message +
                                                      " " +
                                                      emailAddress);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => MainPage(
                                                          selectedIndex: 0)));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: message);
                                            }
                                          }
                                        },
                                      )),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  // fontSize:
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignIn()));
                                },
                                child: Text(
                                  "Sign In Now",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )),
                        )),
                  ),
                ],
              )),
        ));
  }

  Future<void> _registerUser() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        isFormValidated = true;
        callForRegistration = true;
      });

      try {
        // Fetch sign-in methods for the email address
        final list = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(emailController.text);

        // In case list is not empty
        if (list.isNotEmpty) {
          // Return true because there is an existing
          // user using the email address
          message = "User already exists...!";
          _success = false;
        } else {
          // Return false because email adress is not in use

          final User? firebaseUser =
              (await _firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: setPasswordController.text,
          ))
                  .user;

          if (firebaseUser != null) {
            // setState(() async {
            // });

            await firebaseUser.updateDisplayName(userNameController.text);
            await firebaseUser.updateEmail(emailController.text);
            await firebaseUser.updatePassword(setPasswordController.text);

            _success = true;
            emailAddress = firebaseUser.email!;
            message = "User Registered Successfully..!";

            Users user = Users(
                userNameController.text,
                emailController.text,
                mobileNumberController.text,
                setPasswordController.text,
                "",
                "");
            databaseReference.child(firebaseUser.uid).set(user.toJson());
          } else {
            // setState(() {
            // });

            message = "Error while Registering User..!";
            _success = false;
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _success = false;
          message = e.message.toString();
          debugPrint("error: ${e.message.toString()}");
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    mobileNumberController.dispose();
    setPasswordController.dispose();
    super.dispose();
  }
}
