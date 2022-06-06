import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_home.dart';
import 'package:online_cake_ordering/screens/user/login_screen.dart';
import 'package:online_cake_ordering/screens/user/sign_up_screen.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  late DatabaseReference databaseReference;
  late String message;
  late bool _success;
  bool isFormValidated = false;
  bool callForLogin = false;
  late String adminEmail;
  late String adminPassword;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _adminLoginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    databaseReference = FirebaseDatabase.instance
        .ref()
        .child(StringAssets.firebaseAdminCredentials);
    message = "";
    callForLogin = false;
    isFormValidated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: callForLogin,
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
                            top: MediaQuery.of(context).size.height * 0.2),
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
                                      "Admin Login",
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
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SmallButton(
                                        text: "Admin",
                                        color: AppColors.primaryColor,
                                        textColor: AppColors.whiteColor,
                                        onPress: () {},
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SmallButton(
                                        text: "Sign up",
                                        color: AppColors.lightGrey,
                                        textColor: AppColors.blackColor,
                                        onPress: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SignUp()),
                                              (Route<dynamic> route) => false);
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SmallButton(
                                        text: "Sign in",
                                        color: AppColors.lightGrey,
                                        textColor: AppColors.blackColor,
                                        onPress: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SignIn()),
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
                                  key: _adminLoginFormKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FormFieldsWidgets.headingFormField(
                                            context, "Admin Email"),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        EmailFormField(
                                            emailController: emailController,
                                            isEditable: true),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        FormFieldsWidgets.headingFormField(
                                            context, "Admin Password"),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        PasswordFormField(
                                            passwordController:
                                                passwordController),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () async {
                                //           debugPrint("click");
                                //           //Navigator.push(context, Transitions(page: ForgetPassword()));
                                //           Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePassword()));
                                //         },
                                //         child: Text(
                                //           "Forgot Password?",
                                //           style: TextStyle(
                                //             color: AppColors.blackColor,
                                //             fontSize: MediaQuery.of(context).size.width * 0.04,
                                //             // fontSize:
                                //           ),
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Builder(
                                  builder: (ctx) => DefaultButton(
                                    text: "Sign In",
                                    onPress: () async {
                                      await _signInWithEmailAndPassword();

                                      if (message != "") {
                                        setState(() {
                                          callForLogin = false;
                                        });
                                      }

                                      if (message != "") {
                                        if (_success == true) {
                                          Fluttertoast.showToast(
                                              msg: message + " " + adminEmail);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const AdminHome()));
                                        } else {
                                          Fluttertoast.showToast(msg: message);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              )),
        ));
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_adminLoginFormKey.currentState!.validate()) {
      setState(() {
        isFormValidated = true;
        callForLogin = true;
      });

      try {
        // Fetch sign-in methods for the email address
        final list = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(emailController.text);

        debugPrint(emailController.text);
        debugPrint(list.length.toString());

        // In case list is not empty
        if (list.isNotEmpty) {
          // Return true because there is an existing
          // user using the email address
          final User? firebaseUser =
              (await _firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          ))
                  .user;

          if (firebaseUser != null) {
            databaseReference.child(firebaseUser.uid).get().then((docSnapshot) {
              String email = docSnapshot.child("adminEmail").value.toString();
              String password =
                  docSnapshot.child("adminPassword").value.toString();

              if (email == firebaseUser.email) {
                setState(() {
                  callForLogin = false;
                  _success = true;
                  message = "Admin Login Successfully..!";
                  adminEmail = firebaseUser.email!;
                });
              }
            });
          } else {
            debugPrint("No admin credential..");
            setState(() {
              message = "Error while LoggingIn..!";
              callForLogin = false;
              _success = false;
            });
          }
        } else {
          // Return false because email adress is not in use
          setState(() {
            _success = false;
            message = "Please enter valid admin credentials..!";
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _success = false;
          message = e.message.toString();
        });

        // switch (e.code) {
        //   case "invalid-email":
        //     setState(() {
        //       _success = false;
        //       message = e.message.toString();
        //     });
        //     break;
        //   case "too-many-requests":
        //     setState(() {
        //       _success = false;
        //       message = e.message.toString();
        //     });
        //     break;
        // }
      }
    }

    debugPrint("message $message");
    debugPrint("callForLogin $callForLogin");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
