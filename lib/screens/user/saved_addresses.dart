import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/user_addresses_controller.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/custom_order_placing.dart';
import 'package:online_cake_ordering/screens/user/select_shipping_address.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'add_address.dart';

class SavedAddresses extends StatefulWidget {
  const SavedAddresses({Key? key, required this.isSelectable, required this.type}) : super(key: key);
  final bool isSelectable;
  final int type;

  @override
  _SavedAddressesState createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {

  final UserAddressesController _userAddressesController = Get.put(UserAddressesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userAddressesController.fetchUserAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: customAppBar("Saved Addresses"),
      body: SingleChildScrollView(
        child: GetBuilder<UserAddressesController>(
            builder: (_) =>
            _userAddressesController.isAddressesLoading
                ? defaultLoader(context)
                : !_userAddressesController.isAddressesLoading && _userAddressesController.userAddressesList.isNotEmpty
                ? Expanded(
                child: ListView.builder(
                    itemCount: _userAddressesController.userAddressesList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext bContext, int position) {
                      AddressModel addressData = _userAddressesController.userAddressesList[position];
                      return buildAddresses(addressData);
                    })
            )
                : emptyContainer(context, "No address found. \nClick the (add) button to add a new address.")
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isUserLoggedIn()) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAddress()));
          }
          else {
            Fluttertoast.showToast(msg: "Please login first!");
          }
        },
        child: const Icon(Icons.add, color: AppColors.whiteColor),
        backgroundColor: AppColors.kAccentColor,
      ),
    );
  }

  Widget buildAddresses(AddressModel addressModel) {
    return InkWell(
      onTap: () {
        if(widget.isSelectable) {
          StringAssets.addressModel = addressModel;
          if(widget.type == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ShippingAddressSelection()));
          }
          else if(widget.type == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomOrderPlacing()));
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          //border: Border.all(),
          boxShadow: [
            BoxShadow(color: AppColors.smokeWhiteColor, spreadRadius: 1.5),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.location_pin), color: AppColors.kAccentColor, onPressed: () {}),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: customTextWidget(addressModel.fullName, 14.0, AppColors.kAccentColor, FontWeight.bold)
                          ),
                          Visibility(
                            visible: addressModel.isDefaultShippingAddress,
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  color: AppColors.backgroundGrey,
                                ),
                                child: customTextWidget("Default shipping address", 12.0, Colors.black, FontWeight.normal)
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                color: AppColors.kAccentColor,
                              ),
                              child: customTextWidget(addressModel.addressType, 12.0, Colors.white, FontWeight.normal)
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: customTextWidget("Phone Number: ${addressModel.phoneNumber}", 15.0, AppColors.greyColor, FontWeight.normal),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: customTextWidget("Address: ${addressModel.deliveryAddress}", 15.0, AppColors.greyColor, FontWeight.normal),
                    ),
                    const SizedBox(height: 10.0)
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
