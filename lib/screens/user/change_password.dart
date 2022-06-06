import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'main_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  late String message;
  final bool _success = false;
  bool isFormValidated = false;
  bool callForChangePassword = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    message = "";
    callForChangePassword = false;
    isFormValidated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: callForChangePassword,
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
                        margin:EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
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
                              child:Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width * 0.060,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Form(
                                    key: _changePasswordFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30,right: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FormFieldsWidgets.headingFormField(context, "Old Password"),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          PasswordFormField(passwordController: oldPasswordController),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FormFieldsWidgets.headingFormField(context, "New Password"),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          PasswordFormField(passwordController: newPasswordController),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Builder(
                                      builder: (ctx) => DefaultButton(
                                        text: "Change Password",
                                        onPress: () async {

                                          await _changePassword();

                                          if(message != "") {
                                            setState(() {
                                              callForChangePassword = false;
                                            });
                                          }

                                          if(message != "") {
                                            if(_success == true) {
                                              Fluttertoast.showToast(msg: message);
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage(selectedIndex: 0)));
                                            }
                                            else {
                                              Fluttertoast.showToast(msg: message);
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

  Future<void> _changePassword() async {

    if (_changePasswordFormKey.currentState!.validate()) {

      setState(() {
        isFormValidated = true;
        callForChangePassword = true;
      });
    }

    debugPrint(callForChangePassword.toString());
    debugPrint(message);

  }

}
