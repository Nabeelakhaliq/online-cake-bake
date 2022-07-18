import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/generated/assets.dart';
import 'package:online_cake_ordering/models/address_model.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'order_confirm.dart';

ProgressDialog? progressDialog;

class PaymentMethod extends StatefulWidget {

  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {

  File? file;
  late String orderedProductsKey;
  late String orderedProductsDAKey;
  late String orderKey;
  bool isSelected = false;
  late String orderDate;
  late String imageUrl;
  int selectedPaymentMethod = 1;
  String paymentMethod = "Online Payment";

  Reference firebaseStorage = FirebaseStorage.instance.ref().child(StringAssets.paymentSSStorageReference);
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.userOrdersDetails).child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference databaseReferenceAdmin = FirebaseDatabase.instance.ref().child(StringAssets.adminUsersOrdersData);
  DatabaseReference dbRefOrderedProducts = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProducts).child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference dbRefDeliveryAddress = FirebaseDatabase.instance.ref().child(StringAssets.userOrderedProductsDeliveryAddress).child(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderKey = databaseReference.push().key!;
    orderedProductsKey = dbRefOrderedProducts.push().key!;
    orderedProductsDAKey = dbRefDeliveryAddress.push().key!;
  }

  @override
  Widget build(BuildContext context) {

    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false,
        showLogs: false);
    SizeConfig().init(context);

    return Scaffold(
      appBar: customAppBar("Payment"),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DefImageTextButton(
            //   text: "JazzCash",
            //   imageUrl: Assets.iconsJazzCash,
            //   fontSize: 16.0,
            //   bgColor: AppColors.whiteColor,
            //   fontWeight: FontWeight.normal,
            //   onPress: () {
            //     Fluttertoast.showToast(msg: "JazzCash is not available yet.");
            //   },
            // ),
            // DefImageTextButton(
            //   text: "EasyPaisa",
            //   imageUrl: Assets.iconsEasyPaisa,
            //   fontSize: 16.0,
            //   bgColor: AppColors.whiteColor,
            //   fontWeight: FontWeight.normal,
            //   onPress: () {
            //     Fluttertoast.showToast(msg: "EasyPaisa is not available yet.");
            //   },
            // ),
            // DefImageTextButton(
            //   text: "Bank Account",
            //   imageUrl: Assets.iconsBankAccount,
            //   fontSize: 16.0,
            //   bgColor: AppColors.whiteColor,
            //   fontWeight: FontWeight.normal,
            //   onPress: () {
            //     Fluttertoast.showToast(msg: "Bank Account is not available yet.");
            //     },
            // ),
            // DefImageTextButton(
            //   text: "Cash on Delivery",
            //   imageUrl: Assets.iconsCashPayment,
            //   fontSize: 16.0,
            //   bgColor: isSelected ? AppColors.grey : AppColors.whiteColor,
            //   fontWeight: FontWeight.normal,
            //   onPress: () {
            //     changeSelection();
            //   },
            // ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              color: AppColors.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: customTextWidget("Payment Method", 20.0, Colors.black, FontWeight.bold),
                    // child: customTextWidget("Payment methods", 18.0, Colors.black, FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        RadioListTile(
                            title: const Text("Online Payment"),
                            value: 1,
                            groupValue: selectedPaymentMethod,
                            contentPadding: const EdgeInsets.all(0),
                            selectedTileColor: AppColors.kAccentColor,
                            activeColor: AppColors.kAccentColor,
                            onChanged: (int? val) {
                              setState(() {
                                selectedPaymentMethod = val!;
                                paymentMethod = "Online Payment";
                              });
                        }),
                        RadioListTile(
                            title: const Text("Cash on Delivery"),
                            value: 2,
                            groupValue: selectedPaymentMethod,
                            selectedTileColor: AppColors.kAccentColor,
                            activeColor: AppColors.kAccentColor,
                            contentPadding: const EdgeInsets.all(0),
                            onChanged: (int? val) {
                              setState(() {
                                selectedPaymentMethod = val!;
                                paymentMethod = "Cash on Delivery";
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: selectedPaymentMethod == 1,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.lightColorGrey,
                    width: 1.0
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: customTextWidget("Payment ScreenShot", 20.0, Colors.black, FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      child: textWidget("Deposite the Payment in one of the following Accounts", 16.0, Colors.black, FontWeight.normal),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      child: textWidget("Upload Payment Screenshot Here!", 14.0, AppColors.lightGreyColor, FontWeight.normal),
                    ),
                    const SizedBox(height: 30.0),
                    InkWell(
                      onTap: () => pickSSFromGallery(),
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: DottedBorder(
                          color: AppColors.grey, //color of dotted/dash line
                          strokeWidth: 2, //thickness of dash/dots
                          dashPattern: const [5, 5], //dash patterns, 10 is dash width, 6 is space width
                          child: file != null
                              ? Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(file!),
                                    fit: BoxFit.cover
                                )
                            ),
                          )
                              : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(Assets.imagesUploadPaymentSS, color: AppColors.grey),
                                Container(
                                  child: textWidget("Click to choose the file or drag it here", 14.0, AppColors.lightGreyColor, FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              color: AppColors.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: customTextWidget("Order Details", 20.0, Colors.black, FontWeight.bold),
                    // child: customTextWidget("Payment methods", 18.0, Colors.black, FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextWidget("Subtotal (${StringAssets.noOfItems} items)", 16.0, Colors.black, FontWeight.normal),
                        customTextWidget("Rs. ${StringAssets.subTotal}", 16.0, Colors.black, FontWeight.bold)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextWidget("Shipping Fee", 16.0, Colors.black, FontWeight.normal),
                        customTextWidget("Rs. ${StringAssets.shippingFee}", 16.0, Colors.black, FontWeight.bold)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  horizontalDivider(),
                  const SizedBox(height: 5.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextWidget("Total :", 20.0, AppColors.kAccentColor, FontWeight.normal),
                        customTextWidget("Rs. ${StringAssets.totalPrice}", 20.0, AppColors.kAccentColor, FontWeight.bold)
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  horizontalDivider(),
                ],
              ),
            ),
            Visibility(
                visible: selectedPaymentMethod == 1 ,
                child: Column(
                  children: [
                    RadioListTile(
                        value: true,
                        activeColor: AppColors.kAccentColor,
                        tileColor: AppColors.blackColor,
                        title: const Text("Online Payment Methods", style: TextStyle(fontWeight: FontWeight.bold)),
                        groupValue: true,
                        selected: true,
                        contentPadding: const EdgeInsets.all(0),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("NAYAPAY"),
                        subtitle: const Text("0336-2062020 (ALI IMRAN)"),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("EasyPaisa"),
                        subtitle: const Text("0348-0694422 (ALI IMRAN)"),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("EasyPaisa"),
                        subtitle: const Text("0336-8102020 (SAJIDA PARVEEN)"),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("JazzCash"),
                        subtitle: const Text("0336-2062020 (ALI IMRAN)"),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("MEEZAN Bank"),
                        subtitle: const Text("13010105840562 (ALI IMRAN)"),
                        onChanged: (value) {}
                    ),
                    CheckboxListTile(
                        value: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.kAccentColor,
                        checkColor: AppColors.whiteColor,
                        title: const Text("UBL Bank"),
                        subtitle: const Text("1677246851646 (ALI IMRAN)"),
                        onChanged: (value) {}
                    ),
                  ],
                )
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(10),
          horizontal: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: getProportionateScreenWidth(190),
            child: CustomButton(
              text: "Confirm Order",
              press: () async {
                if(selectedPaymentMethod == 1) {
                  if(file != null) {
                    showAlertDialog(context);
                  }
                  else {
                    Fluttertoast.showToast(msg: "Please upload payment screenshot!");
                  }
                }
                else {
                  showAlertDialog(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  pickSSFromGallery() async {

    // ignore: deprecated_member_use
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      file = File(imageFile!.path);
    });
  }

  changeSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: const Text("Cancel", style: TextStyle(color: AppColors.kAccentColor)),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.kAccentColor),),
      onPressed:  () async {
        Navigator.pop(context);
        progressDialog!.show();
        if(selectedPaymentMethod == 1) {
          uploadPaymentScreenShot();
        }
        else {
          saveOrderDetails();
        }
        // await saveOrderDetails();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm?"),
      content: Text("Total ${StringAssets.noOfItems} (items): ${StringAssets.totalPrice} PKR"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  uploadPaymentScreenShot() async {

    String fileName = getFileName(file!);
    debugPrint("fileName $fileName");

    var snapshot = await firebaseStorage.child('/$fileName')
        .putFile(file!).whenComplete(() {
      debugPrint("Uploaded...!");
    });

    await snapshot.ref.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
        debugPrint(imageUrl);
      });
    });

    saveOrderDetails();
  }

  getFileName(File mFile) {
    String fileName = mFile.path.split('/').last;

    return fileName;
  }

  saveOrderDetails() {

    // region Save Cart Products
    for (var element in StringAssets.cartProductsList) {
      ProductModel productModel = ProductModel(element.productCategory, element.productID,
          element.productImage, element.productName, element.productDescription,
          element.productPrice, element.productOldPrice, element.productStockQuantity,
          element.isFeatured, element.isRecommended);

      dbRefOrderedProducts.child(orderedProductsKey).push().set(productModel.toJson());
    }
    // endregion

    // region Save Delivery Address & Order Details
    AddressModel addressModel = AddressModel(StringAssets.addressModel!.fullName,
        StringAssets.addressModel!.phoneNumber, StringAssets.addressModel!.provinceName,
        StringAssets.addressModel!.cityName, StringAssets.addressModel!.deliveryAddress,
        StringAssets.addressModel!.addressType, StringAssets.addressModel!.isDefaultShippingAddress);

    dbRefDeliveryAddress.child(orderedProductsDAKey).set(addressModel.toJson()).whenComplete(() {

      OrderModel orderModel = OrderModel(getOrderDate(), FirebaseAuth.instance.currentUser!.uid,
          orderedProductsKey, orderedProductsDAKey, orderKey, "Pending", selectedPaymentMethod == 1 ? "Paid" : "Pending",
          StringAssets.noOfItems, StringAssets.subTotal.toStringAsFixed(2),
          StringAssets.shippingFee.toStringAsFixed(2), StringAssets.totalPrice.toStringAsFixed(2),
          paymentMethod, selectedPaymentMethod == 1 ? imageUrl : "");

      databaseReference.child(orderKey).set(orderModel.toJson()).whenComplete(() {

        databaseReferenceAdmin.child(orderKey).set(orderModel.toJson()).whenComplete(() {
          FirebaseDatabase.instance.ref().child(StringAssets.userCartData)
              .child(FirebaseAuth.instance.currentUser!.uid).remove().whenComplete(() {

            StringAssets.cartProductsList.clear();
            StringAssets.subTotal = 0;
            StringAssets.totalPrice = 0;
            StringAssets.noOfItems = 0;
            file = null;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderConfirmation(isSuccess: true, paymentMethod: "Cash on Delivery",)));
          });
        });
      });
    });
    // endregion

    progressDialog!.hide();
  }

  getCurrentDateTime() {

    String dateTime;
    var now = DateTime.now();
    var formatterDate = DateFormat('dd-MM-yy');
    var formatterTime = DateFormat('HH:mm:ss');
    String currentDate = formatterDate.format(now);
    String currentTime = formatterTime.format(now);

    dateTime = currentDate + "_" + currentTime;

    debugPrint(dateTime);

    return dateTime;
  }

  String getOrderDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("EEE dd, yyyy, hh:mm a");
    orderDate = formatter.format(now);

    debugPrint(orderDate);
    return orderDate;
  }
}