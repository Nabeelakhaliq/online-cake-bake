import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/saved_addresses.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.usersAddressesData);
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _addAddressFormKey = GlobalKey<FormState>();
  List<String> list = ["Home", "Office"];
  int selectedIndex = 0;
  late String message;
  bool isSwitch = false;
  bool _success = false;
  bool callForAddAddress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = "";
    callForAddAddress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: customAppBar("Add Address"),
      body: ModalProgressHUD(
        inAsyncCall: callForAddAddress,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: customTextWidget("Enter Details", 18.0, Colors.black, FontWeight.bold),
              ),
              Form(
                key: _addAddressFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormFieldsWidgets.defHeadingFormField(context, "Full Name"),
                      const SizedBox(height: 5.0),
                      CustomFormField(
                        textEditingController: fullNameController,
                        hintText: "Enter Full Name",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        nullError: "Full Name Required",
                      ),
                      const SizedBox(height: 10.0),
                      FormFieldsWidgets.defHeadingFormField(context, "Phone Number"),
                      const SizedBox(height: 5.0),
                      FormFieldsWidgets.mobileFormField(phoneNumberController, context),
                      const SizedBox(height: 10.0),
                      FormFieldsWidgets.defHeadingFormField(context, "Province"),
                      const SizedBox(height: 5.0),
                      CustomFormField(
                        textEditingController: provinceController,
                        hintText: "Enter Province",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        nullError: "Province Required",
                      ),
                      const SizedBox(height: 10.0),
                      FormFieldsWidgets.defHeadingFormField(context, "City"),
                      const SizedBox(height: 5.0),
                      CustomFormField(
                        textEditingController: cityController,
                        hintText: "Enter City",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        nullError: "City Name Required",
                      ),
                      const SizedBox(height: 10.0),
                      FormFieldsWidgets.defHeadingFormField(context, "Delivery Address"),
                      const SizedBox(height: 5.0),
                      CustomFormField(
                        textEditingController: addressController,
                        hintText: "Enter Delivery Address",
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        nullError: "Delivery Address Required",
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleSwitch(
                            minWidth: 90.0,
                            initialLabelIndex: selectedIndex,
                            cornerRadius: 10.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            dividerColor: Colors.blueGrey,
                            totalSwitches: 2,
                            iconSize: 20.0,
                            //radiusStyle: true,
                            labels: const ['Home', 'Office'],
                            icons: const [Icons.home, Icons.shopping_bag],
                            activeBgColors: const [[AppColors.kAccentColor], [AppColors.kAccentColor]],
                            onToggle: (index) {
                              setState(() {
                                selectedIndex = index!;
                              });
                              debugPrint('switched to: $index');
                              debugPrint('switched to: ${list[selectedIndex]}');
                            },
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: IconTextButton(
                      //         text: 'Office',
                      //         backgroundColor: AppColors.whiteColor,
                      //         fontSize: 14.0,
                      //         fontWeight: FontWeight.bold,
                      //         iconData: Icons.shopping_bag,
                      //         iconSize: 25.0,
                      //         alignment: MainAxisAlignment.center,
                      //         onPress: () {
                      //           setState(() {
                      //
                      //           });
                      //           //Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut()));
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: IconTextButton(
                      //         text: 'Home',
                      //         backgroundColor: AppColors.whiteColor,
                      //         fontSize: 14.0,
                      //         fontWeight: FontWeight.bold,
                      //         iconData: Icons.home,
                      //         iconSize: 25.0,
                      //         alignment: MainAxisAlignment.center,
                      //         onPress: () {
                      //           //Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut()));
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 10.0),
                      const Divider(
                        thickness: 1.5,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.black12,
                        height: 5,
                      ),
                      SwitchListTile(
                        value: isSwitch,
                        title: myCustomTextWidget("Make it default shipping address", 14.0, Colors.black, FontWeight.normal),
                        activeColor: AppColors.kAccentColor,
                        onChanged: (bool val) {
                          setState(() {
                            isSwitch = !isSwitch;
                          });
                        },
                      ),
                      const Divider(
                        thickness: 1.5,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.black12,
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: DefIconTextButton(
                          text: 'Save Address',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          iconData: Icons.save,
                          onPress: () async {
                            await _saveAddress();

                            if(message != "") {
                              setState(() {
                                callForAddAddress = false;
                              });
                            }

                            if(message != "") {
                              if(_success == true) {
                                Fluttertoast.showToast(msg: message);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SavedAddresses(isSelectable: false, type: 0,)));
                              }
                              else {
                                Fluttertoast.showToast(msg: message);
                              }
                            }

                            debugPrint("message $message");
                            debugPrint("_success $_success");
                            debugPrint("callForAddAddress $callForAddAddress");

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {

    if (_addAddressFormKey.currentState!.validate()) {

      setState(() {
        callForAddAddress = true;
      });

      AddressModel addressModel = AddressModel(
          fullNameController.text, phoneNumberController.text, provinceController.text,
          cityController.text, addressController.text, list[selectedIndex], isSwitch);

      try {
        await databaseReference.child(FirebaseAuth.instance.currentUser!.uid).push().set(addressModel.toJson()).whenComplete(() {
          setState(() {
            _success = true;
            message = "Address Added Successfully..!";
            debugPrint("message : $message");
            debugPrint("_success : $_success");
          });
        });
      } on FirebaseAuthException catch (e) {

        setState(() {
          _success = false;
          message = e.message.toString();
          debugPrint("error: ${e.message.toString()}");
          debugPrint("message $message");
          debugPrint("_success : $_success");
        });
      }
    }

    // if (kDebugMode) {
    //   debugPrint("message $message");
    //   debugPrint("_success : $_success");
    // }
  }

}
