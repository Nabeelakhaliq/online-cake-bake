import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/main_page.dart';
import 'package:online_cake_ordering/widgets/decorated_container_widgets.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:online_cake_ordering/config/size_config.dart';

int selectedQuantity = 1;

class ProductDetails extends StatefulWidget {

  ProductDetails({Key? key, required this.productModel}) : super(key: key);
  NewProductModel productModel;

  @override
  _ProductDetailsState createState() => _ProductDetailsState(productModel: productModel);
}

class _ProductDetailsState extends State<ProductDetails> {

  _ProductDetailsState({required this.productModel});
  final NewProductModel productModel;

  late DatabaseReference dbUserCartReference;
  String userID = "";
  bool isAlreadyInCart = false;

  String dummyText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLogin();
    debugPrint(productModel.productID);
    dbUserCartReference = FirebaseDatabase.instance.ref().child(StringAssets.userCartData);
  }

  @override
  Widget build(BuildContext context) {
    
    SizeConfig().init(context);
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double roundImage = 50;
    //SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildImageContainer(height, roundImage),
              Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextTitle(),
                    const SizedBox(height: 12),
                    _buildRowPriceRating(),
                    const SizedBox(height: 12),
                    _buildRowProductCounter(context),
                    const SizedBox(height: 12),
                    Text(
                      dummyText,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  //color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundImage),
                  ),
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: TopRoundedContainer(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.screenWidth * 0.05,
              right: SizeConfig.screenWidth * 0.05,
              bottom: getProportionateScreenWidth(5),
              top: getProportionateScreenWidth(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if(userID != "") {

                        await checkForProductInCart(productModel.productID);

                        if(isAlreadyInCart) {
                          Fluttertoast.showToast(msg: "Product already in cart!");
                        }
                        else {
                          settingModalBottomSheet(productModel);
                        }
                      }
                      else {
                        Fluttertoast.showToast(msg: "Please login first!");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DecoratedContainerWidgets.decoratedIconTextContainer("Add to Cart", Icons.add_shopping_cart, AppColors.kAccentColor),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if(userID != "") {

                        await checkForProductInCart(productModel.productID);

                        // if(isAlreadyInCart) {
                        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainPage(selectedIndex: 2)));
                        // }
                        // else {
                        //   settingModalBottomSheetForBuyNow(productModel);
                        // }
                      }
                      else {
                        Fluttertoast.showToast(msg: "Please login first!");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DecoratedContainerWidgets.decoratedIconTextContainer("Buy Now", Icons.shopping_bag, AppColors.kAccentColor),
                    ),
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: SmallButton(
            //         color: AppColors.primaryColor,
            //         textColor: AppColors.white,
            //         text: "Add to Cart",
            //         onPress: () async {
            //           if(userID != "") {
            //
            //             await checkForProductInCart(productModel.productID);
            //
            //             if(isAlreadyInCart) {
            //               Fluttertoast.showToast(msg: "Product already in cart!");
            //             }
            //             else {
            //               settingModalBottomSheet(productModel);
            //               // dbUserCartReference.child(userID).child(productModel.productID).set(productModel.toJson()).whenComplete(() {
            //               //   _alert(context);
            //               // });
            //             }
            //           }
            //           else {
            //             Fluttertoast.showToast(msg: "Please login first!");
            //           }
            //         },
            //       ),
            //     ),
            //     const SizedBox(width: 10.0),
            //     Expanded(
            //       child: SmallButton(
            //         color: AppColors.kAccentColor,
            //         textColor: AppColors.white,
            //         text: "Buy Now",
            //         onPress: () {},
            //       ),
            //     ),
            //   ],
            // )
          )
      )
    );
  }

  Row _buildRowProductCounter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MaterialButton(
              onPressed: () {
                debugPrint('Plus btn tapped');
              },
              color: AppColors.kAccentColor,
              textColor: Colors.white,
              child: const Icon(
                CupertinoIcons.plus_circled,
                size: 24,
              ),
              padding: const EdgeInsets.all(10),
              shape: const CircleBorder(),
            ),
            const Text(
              "4.8",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              onPressed: () {
                debugPrint('Minus btn tapped');
              },
              color: AppColors.kAccentColor,
              textColor: Colors.white,
              child: const Icon(
                CupertinoIcons.minus_circled,
                size: 24,
              ),
              padding: const EdgeInsets.all(10),
              shape: const CircleBorder(),
            ),
          ],
        ),
        Expanded(
          child:  Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              width: getProportionateScreenWidth(64),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE6E6),
                //product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                ImageAssets.iconsHeartIcon,
                color: const Color(0xFFFF4848),
                //product.isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
                height: getProportionateScreenWidth(16),
              ),
            ),
          ),
        )
        // RaisedButton(
        //   onPressed: () => {
        //     // Navigator.push(
        //     //     context, MaterialPageRoute(builder: (context) => CartPage())),
        //   },
        //   child: const Text(
        //     'Add To Cart',
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   color: AppColors.kAccentColor,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //       side: const BorderSide(color: AppColors.kAccentColor)),
        // ),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Shopping Cart"),
      content: const Text("Your product has been added to cart."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _alert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: AppColors.kAccentColor,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Shopping Cart",
      desc: "Your product has been added to cart.",
      buttons: [
        DialogButton(
          child: const Text(
            "BACK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: const Text(
            "GO CART",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainPage(selectedIndex: 2)));
          },
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  Row _buildRowPriceRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Price : ${productModel.productPrice} (Rs.)",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        SmoothStarRating(
            allowHalfRating: false,
            onRated: (v) {},
            starCount: 5,
            rating: 4.2,
            size: 20.0,
            isReadOnly: true,
            color: AppColors.kAccentLightColor,
            borderColor: Colors.green,
            spacing: 0.0),
        const Text(
          "Rating: 4.8",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Text _buildTextTitle() {
    return Text(
      productModel.productName,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Container _buildImageContainer(double height, double roundImage) {
    return Container(
      color: Colors.grey.shade200,
      height: (2 * (height / 3)) - 150,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(roundImage),
          bottomRight: Radius.circular(roundImage)
        ),
        child: Hero(
          tag: productModel.productID,
          child: Image.network(
            productModel.productImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void checkUserLogin() {
    if(isUserLoggedIn()) {
      setState(() {
        userID = FirebaseAuth.instance.currentUser!.uid;
      });
    }
  }

  checkForProductInCart(String productID) async {
    await dbUserCartReference.child(userID).once().then((value) {
      for (var element in value.snapshot.children) {
        if(element.key == productModel.productID) {
          debugPrint("${element.key} : ${productModel.productID}");
          setState(() {
            isAlreadyInCart = true;
          });
        }
      }
    });
  }

  void settingModalBottomSheet(NewProductModel productObject) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
              builder: (BuildContext mContext, StateSetter setState) {
                return Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  color: AppColors.white,
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedQuantity = 1;
                              });
                              Navigator.of(context).pop();
                            },
                            color: AppColors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const Text("Quantity"),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedQuantity > 1) {
                                              selectedQuantity--;
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: AppColors.whiteColor,
                                          size: 30,
                                        )),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 6, right: 6),
                                      child: Text(
                                        selectedQuantity.toString().padLeft(2, "0"),
                                        //style: AppStyles.kQuantityStyle,
                                      )),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedQuantity++;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add_circle,
                                          color: AppColors.whiteColor,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        RaisedButton(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                  color: AppColors.kAccentColor)),
                          onPressed: () {
                            //waitingDialog(context, 'please wait');
                            ProductModel cartModel = ProductModel(productModel.productMainCategory, productModel.productID, productModel.productImage, productModel.productName, productModel.productDescription, productModel.productPrice, productModel.productOldPrice, selectedQuantity, productModel.isFeatured, productModel.isRecommended);

                            dbUserCartReference.child(userID).child(productModel.productID).set(cartModel.toJson()).whenComplete(() {
                              _alert(context);
                            });

                            Navigator.pop(context);
                            setState(() {
                              selectedQuantity = 1;
                            });
                          },
                          color: AppColors.kAccentColor,
                          textColor: AppColors.whiteColor,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: const Text(
                              'Add To Cart',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void settingModalBottomSheetForBuyNow(NewProductModel productObject) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
              builder: (BuildContext mContext, StateSetter setState) {
                return Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  color: AppColors.white,
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedQuantity = 1;
                              });
                              Navigator.of(context).pop();
                            },
                            color: AppColors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const Text("Quantity"),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedQuantity > 1) {
                                              selectedQuantity--;
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: AppColors.whiteColor,
                                          size: 30,
                                        )),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 6, right: 6),
                                      child: Text(
                                        selectedQuantity.toString().padLeft(2, "0"),
                                        //style: AppStyles.kQuantityStyle,
                                      )),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedQuantity++;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add_circle,
                                          color: AppColors.whiteColor,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        RaisedButton(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                  color: AppColors.kAccentColor)),
                          onPressed: () {
                            ProductModel cartModel = ProductModel(productModel.productMainCategory, productModel.productID, productModel.productImage, productModel.productName, productModel.productDescription, productModel.productPrice, productModel.productOldPrice, selectedQuantity, productModel.isFeatured, productModel.isRecommended);

                            dbUserCartReference.child(userID).child(productModel.productID).set(cartModel.toJson()).whenComplete(() {
                              _alert(context);
                            });

                            Navigator.pop(context);
                            setState(() {
                              selectedQuantity = 1;
                            });
                          },
                          color: AppColors.kAccentColor,
                          textColor: AppColors.whiteColor,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: const Text(
                              'Add To Cart',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
  // endregion
}
