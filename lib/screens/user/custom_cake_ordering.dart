import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_cake_ordering/models/custom_cart_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/custom_order_placing.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

class CustomCakeOrdering extends StatefulWidget {
  const CustomCakeOrdering({Key? key}) : super(key: key);

  @override
  State<CustomCakeOrdering> createState() => _CustomCakeOrderingState();
}

class _CustomCakeOrderingState extends State<CustomCakeOrdering> {

  final _customOrderFormKey = GlobalKey<FormState>();
  TextEditingController ingTextEditingController = TextEditingController();
  List<String> cakePoundsList = ["1 Pound", "2 Pounds", "3 Pounds", "4 Pounds", "5 Pounds", "6 Pounds", "7 Pounds", "8 Pounds", "9 Pounds", "10 Pounds"];
  List<String> cakeFlavoursList = ["Chocolate", "Lemon", "White Chocolate", "Vanilla", "Coconut", "Lime", "Pineapple", "Coconut + Lime", "Strawberry"];
  List<String> cakeCategoryList = ["Birthday", "Wedding", "Anniversary", "Success Party", "Function", "Any Other"];
  String? selectedPound;
  String? selectedFlavour;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Custom Cake Ordering"),
      body: Form(
        key: _customOrderFormKey,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.perm_device_info, color: Colors.pink),
              title: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: AppColors.kAccentColor
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        color: AppColors.whiteColor
                    ),
                    child: DropdownButton<String>(
                      hint:  const Text(
                          "Select Cake Size",
                          style: TextStyle(
                              fontSize: 16.0, color: AppColors.kAccentColor),
                          textAlign: TextAlign.left),
                      value: selectedPound,
                      isExpanded: true,
                      isDense: false,
                      dropdownColor: AppColors.whiteColor,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                      underline: Container(
                        height: 1.0,
                        color: AppColors.whiteColor,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPound = value;
                        });
                      },
                      items: cakePoundsList.map((String value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Text(value, style: const TextStyle(
                              fontSize: 16.0, color: AppColors.blackColor,
                            ), textAlign: TextAlign.left),
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ),
            ),
            const Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: const Icon(Icons.perm_device_info, color: Colors.pink),
              title: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: AppColors.kAccentColor
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        color: AppColors.whiteColor
                    ),
                    child: DropdownButton<String>(
                      hint:  const Text(
                          "Select Cake Flavour",
                          style: TextStyle(
                              fontSize: 16.0, color: AppColors.kAccentColor),
                          textAlign: TextAlign.left),
                      value: selectedFlavour,
                      isExpanded: true,
                      isDense: false,
                      dropdownColor: AppColors.whiteColor,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                      underline: Container(
                        height: 1.0,
                        color: AppColors.whiteColor,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedFlavour = value;
                        });
                      },
                      items: cakeFlavoursList.map((String value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Text(value, style: const TextStyle(
                              fontSize: 16.0, color: AppColors.blackColor,
                            ), textAlign: TextAlign.left),
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ),
            ),
            const Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: const Icon(Icons.perm_device_info, color: Colors.pink),
              title: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: AppColors.kAccentColor
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        color: AppColors.whiteColor
                    ),
                    child: DropdownButton<String>(
                      hint:  const Text(
                          "Select an Event",
                          style: TextStyle(
                              fontSize: 16.0, color: AppColors.kAccentColor),
                          textAlign: TextAlign.left),
                      value: selectedCategory,
                      isExpanded: true,
                      isDense: false,
                      dropdownColor: AppColors.whiteColor,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                      underline: Container(
                        height: 1.0,
                        color: AppColors.whiteColor,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: cakeCategoryList.map((String value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Text(value, style: const TextStyle(
                              fontSize: 16.0, color: AppColors.blackColor,
                            ), textAlign: TextAlign.left),
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ),
            ),
            const Divider(
              color: Colors.pink,
            ),
            DefaultFormField(
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textEditingController: ingTextEditingController,
              hintText: "Ingredients",
              nullError: "Required",
            ),
            const Divider(
              color: Colors.pink,
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                text: "NEXT",
                press: () async {
                  if(_customOrderFormKey.currentState!.validate()) {
                    if(selectedPound == null) {
                      Fluttertoast.showToast(msg: "Please select cake size!");
                    }
                    else if(selectedFlavour == null) {
                      Fluttertoast.showToast(msg: "Please select cake flavour!");
                    }
                    else if(selectedCategory == null) {
                      Fluttertoast.showToast(msg: "Please select an event!");
                    }
                    else {
                      CustomCartModel customOrderModel = CustomCartModel(name: "Custom Cake Design", cakeSize: selectedPound!, cakeFlavour: selectedFlavour!, cakeEvent: selectedCategory!, price: 0, quantity: 1, cakeIngredients: ingTextEditingController.text);
                      StringAssets.customCartModel = customOrderModel;
                      debugPrint("StringAssets.customCartModel ${StringAssets.customCartModel?.toJson()}");
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomOrderPlacing()));
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
