import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/controllers/user/user_products_controller.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/home_categories_model.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/all_featured_products.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/image_widgets.dart';
import 'package:online_cake_ordering/widgets/top_promo_slider.dart';
import 'product_details_screen.dart';

int selectedQuantity = 1;
DatabaseReference dbUserCartReference = FirebaseDatabase.instance.ref().child(StringAssets.userCartData);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late double defaultHeight, defaultWidth;
  List<String> categoryList = ["Top Designs", "Custom Designs", "Birthday Cakes", "Anniversary Cakes", "Wedding Cakes", "Fruit Cakes"];
  final UserProductsController _userProductsController = Get.put(UserProductsController());
  bool isAlreadyInCart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProductsController.fetchAllBanners();
    _userProductsController.fetchMainCategories();
    _userProductsController.fetchAllFeaturedProducts();
    _userProductsController.fetchAllRecommendedProducts();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    defaultHeight = SizeConfig.screenHeight;
    defaultWidth = SizeConfig.screenWidth;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GetBuilder<UserProductsController>(
          builder: (_) => SingleChildScrollView(
            child: Column(
              children: [
                _userProductsController.isSlidersLoading
                    ? defaultLoader(context)
                    : !_userProductsController.isSlidersLoading && _userProductsController.imagesList.isNotEmpty
                    ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                    child: TopPromoSlider(defaultHeight * 0.23, defaultWidth, _userProductsController.imagesList))
                    : Container(),
                const SizedBox(height: 10.0),
                _userProductsController.isMainCategoriesLoading
                    ? defaultLoader(context)
                    : !_userProductsController.isMainCategoriesLoading &&
                    _userProductsController.mainCategoriesList.isNotEmpty
                    ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    height: 40.0,
                    child: ListView.builder(
                        itemCount: _userProductsController.mainCategoriesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (bContext, position) {
                          String categoryName = _userProductsController.mainCategoriesList[position];
                          return InkWell(
                              onTap: () {
                                _userProductsController.changeSelectedCategory(position);
                              },
                              child: buildCakeCategory(categoryName, _userProductsController.selectedCategory == position));
                        })
                )
                    : Container(),
                _userProductsController.isCategoryProductsLoading
                    ? defaultLoader(context)
                    : !_userProductsController.isCategoryProductsLoading
                    && _userProductsController.categoryProductsList.isNotEmpty
                    ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    width: double.infinity,
                    child: GridView.builder(
                        itemCount: _userProductsController.categoryProductsList.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          // crossAxisCount: 2,
                          // crossAxisSpacing: 10.0,
                          // mainAxisSpacing: 10.0,
                          childAspectRatio: 0.65,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext bContext, int position) {
                          NewProductModel productModel = _userProductsController.categoryProductsList[position];
                          return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                              },
                              //child: itemsGridWidget(productModel.productImage, productModel.productName, productModel.productPrice + 0, productModel.productPrice + 500));
                              child: buildCategoryProducts(productModel));
                          //return _buildFeaturedProducts(productModel, context);
                        })
                )
                    : Container(),
                _userProductsController.isRecommendedProductsLoading
                    ? defaultLoader(context)
                    : !_userProductsController.isRecommendedProductsLoading
                    && _userProductsController.recommendedProductsList.isNotEmpty
                    ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Recommended",
                            style: TextStyle(
                                color: AppColors.kAccentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        width: double.infinity,
                        child: GridView.builder(
                            itemCount: _userProductsController.recommendedProductsList.length >= 10
                                ? 10 : _userProductsController.recommendedProductsList.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (BuildContext bContext, int position) {
                              NewProductModel productModel = _userProductsController.recommendedProductsList[position];
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                                  },
                                  child: itemsGridWidget(productModel.productImage, productModel.productName, double.parse(productModel.productPrice), double.parse(productModel.productPrice) + 380));
                              //return _buildRecommendedProducts(productModel, context);
                            })
                    ),
                    Visibility(
                      visible: _userProductsController.recommendedProductsList.length >= 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AllFeaturedProducts(featuredProductsList: _userProductsController.recommendedProductsList)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                "See All",
                                style: TextStyle(
                                    color: AppColors.kAccentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
                _userProductsController.isFeaturedProductsLoading
                    ? defaultLoader(context)
                    : !_userProductsController.isFeaturedProductsLoading
                    && _userProductsController.featuredProductsList.isNotEmpty
                    ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Featured",
                            style: TextStyle(
                                color: AppColors.kAccentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        width: double.infinity,
                        child: GridView.builder(
                            itemCount: _userProductsController.featuredProductsList.length >= 10
                                ? 10 : _userProductsController.featuredProductsList.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              // crossAxisCount: 2,
                              // crossAxisSpacing: 10.0,
                              // mainAxisSpacing: 10.0,
                              childAspectRatio: 0.65,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext bContext, int position) {
                              NewProductModel productModel = _userProductsController.featuredProductsList[position];
                              return InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                                  },
                                  //child: itemsGridWidget(productModel.productImage, productModel.productName, productModel.productPrice + 0, productModel.productPrice + 500));
                                  child: buildFeaturedItems(productModel));
                              //return _buildFeaturedProducts(productModel, context);
                            })
                    ),
                    Visibility(
                      visible: _userProductsController.featuredProductsList.length >= 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AllFeaturedProducts(featuredProductsList: _userProductsController.featuredProductsList)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                "See All",
                                style: TextStyle(
                                    color: AppColors.kAccentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Container()
              ],
            ),
          ),
        ),
      ),
      // body: SafeArea(
      //   child: GetBuilder<UserProductsController>(
      //     builder: (_) => SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           GetBuilder<UserProductsController>(
      //               builder: (_) => _userProductsController.isSlidersLoading
      //                   ? defaultLoader(context)
      //                   : !_userProductsController.isSlidersLoading && _userProductsController.imagesList.isNotEmpty
      //                   ? Container(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      //                   child: TopPromoSlider(defaultHeight * 0.23, defaultWidth, _userProductsController.imagesList))
      //                   : Container()
      //           ),
      //           const SizedBox(height: 10.0),
      //           GetBuilder<UserProductsController>(
      //               builder: (_) => _userProductsController.isMainCategoriesLoading
      //                   ? defaultLoader(context)
      //                   : !_userProductsController.isMainCategoriesLoading &&
      //                   _userProductsController.mainCategoriesList.isNotEmpty
      //                   ? Container(
      //                   margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      //                   height: 40.0,
      //                   child: ListView.builder(
      //                       itemCount: _userProductsController.mainCategoriesList.length,
      //                       scrollDirection: Axis.horizontal,
      //                       itemBuilder: (bContext, position) {
      //                         String categoryName = _userProductsController.mainCategoriesList[position];
      //                         return InkWell(
      //                             onTap: () {
      //                               _userProductsController.changeSelectedCategory(position);
      //                             },
      //                             child: buildCakeCategory(categoryName, _userProductsController.selectedCategory == position));
      //                       })
      //               )
      //                   : Container()
      //           ),
      //           GetBuilder<UserProductsController>(
      //               builder: (_) => _userProductsController.isMainCategoriesLoading
      //                   ? defaultLoader(context)
      //                   : !_userProductsController.isMainCategoriesLoading && _userProductsController.categoryProductsList.isNotEmpty
      //                   ? Container(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      //                   width: double.infinity,
      //                   child: GridView.builder(
      //                       itemCount: _userProductsController.categoryProductsList.length,
      //                       shrinkWrap: true,
      //                       physics: const BouncingScrollPhysics(),
      //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                         // crossAxisCount: 2,
      //                         // crossAxisSpacing: 10.0,
      //                         // mainAxisSpacing: 10.0,
      //                         childAspectRatio: 0.65,
      //                         mainAxisSpacing: 4,
      //                         crossAxisSpacing: 4,
      //                         crossAxisCount: 2,
      //                       ),
      //                       itemBuilder: (BuildContext bContext, int position) {
      //                         NewProductModel productModel = _userProductsController.categoryProductsList[position];
      //                         return InkWell(
      //                             onTap: () {
      //                               // Navigator.push(
      //                               //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      //                             },
      //                             //child: itemsGridWidget(productModel.productImage, productModel.productName, productModel.productPrice + 0, productModel.productPrice + 500));
      //                             child: buildCategoryProducts(productModel));
      //                         //return _buildFeaturedProducts(productModel, context);
      //                       })
      //               )
      //                   : Container()
      //           ),
      //           GetBuilder<UserProductsController>(
      //               builder: (_) => _userProductsController.isRecommendedProductsLoading
      //                   ? defaultLoader(context)
      //                   : !_userProductsController.isRecommendedProductsLoading && _userProductsController.recommendedProductsList.isNotEmpty
      //                   ? Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.all(10.0),
      //                     child: Row(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: const [
      //                         Text(
      //                           "Recommended",
      //                           style: TextStyle(
      //                               color: AppColors.kAccentColor,
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 20.0
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Container(
      //                       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      //                       width: double.infinity,
      //                       child: GridView.builder(
      //                           itemCount: _userProductsController.recommendedProductsList.length,
      //                           shrinkWrap: true,
      //                           physics: const BouncingScrollPhysics(),
      //                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                             crossAxisCount: 2,
      //                             crossAxisSpacing: 10.0,
      //                             mainAxisSpacing: 10.0,
      //                           ),
      //                           itemBuilder: (BuildContext bContext, int position) {
      //                             NewProductModel productModel = _userProductsController.recommendedProductsList[position];
      //                             return InkWell(
      //                                 onTap: () {
      //                                   Navigator.push(
      //                                       context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      //                                 },
      //                                 child: itemsGridWidget(productModel.productImage, productModel.productName, double.parse(productModel.productPrice), double.parse(productModel.productPrice) + 380));
      //                             //return _buildRecommendedProducts(productModel, context);
      //                           })
      //                   ),
      //                 ],
      //               )
      //                   : Container()
      //           ),
      //           GetBuilder<UserProductsController>(
      //               builder: (_) => _userProductsController.isFeaturedProductsLoading
      //                   ? defaultLoader(context)
      //                   : !_userProductsController.isFeaturedProductsLoading && _userProductsController.featuredProductsList.isNotEmpty
      //                   ? Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.all(10.0),
      //                     child: Row(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: const [
      //                         Text(
      //                           "Featured",
      //                           style: TextStyle(
      //                               color: AppColors.kAccentColor,
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 20.0
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Container(
      //                       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      //                       width: double.infinity,
      //                       child: GridView.builder(
      //                           itemCount: _userProductsController.featuredProductsList.length,
      //                           shrinkWrap: true,
      //                           physics: const BouncingScrollPhysics(),
      //                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                             // crossAxisCount: 2,
      //                             // crossAxisSpacing: 10.0,
      //                             // mainAxisSpacing: 10.0,
      //                             childAspectRatio: 0.65,
      //                             mainAxisSpacing: 4,
      //                             crossAxisSpacing: 4,
      //                             crossAxisCount: 2,
      //                           ),
      //                           itemBuilder: (BuildContext bContext, int position) {
      //                             NewProductModel productModel = _userProductsController.featuredProductsList[position];
      //                             return InkWell(
      //                                 onTap: () {
      //                                   // Navigator.push(
      //                                   //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      //                                 },
      //                                 //child: itemsGridWidget(productModel.productImage, productModel.productName, productModel.productPrice + 0, productModel.productPrice + 500));
      //                                 child: buildFeaturedItems(productModel));
      //                             //return _buildFeaturedProducts(productModel, context);
      //                           })
      //                   ),
      //                 ],
      //               )
      //                   : Container()
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildCategoryProducts(NewProductModel productModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildImage(context, productModel.productImage),
          buildTitle(productModel.productName),
          buildRating(),
          buildPriceInfo(productModel, double.parse(productModel.productPrice.toString()),
                  () async {
                if(isUserLoggedIn()) {

                  await checkForProductInCart(productModel.productID);

                  if(isAlreadyInCart) {
                    Fluttertoast.showToast(msg: "Product already in cart!");
                  }
                  else {
                    settingModalBottomSheet(productModel);
                  }
                }
                else {
                  Fluttertoast.showToast(msg: "Please login to add item(s) in cart!");
                }
              }),
        ],
      ),
    );
  }

  Widget buildFeaturedItems(NewProductModel productModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildImage(context, productModel.productImage),
              buildTitle(productModel.productName),
              buildRating(),
              buildPriceInfo(productModel, double.parse(productModel.productPrice.toString()),
                      () async {
                    if(isUserLoggedIn()) {

                      await checkForProductInCart(productModel.productID);

                      if(isAlreadyInCart) {
                        Fluttertoast.showToast(msg: "Product already in cart!");
                      }
                      else {
                        settingModalBottomSheet(productModel);
                      }
                    }
                    else {
                      Fluttertoast.showToast(msg: "Please login to add item(s) in cart!");
                    }
                  }),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.kAccentColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
              ),
              child: const Text("Shop Name", style: TextStyle(color: AppColors.whiteColor)),
            ),
          )
        ],
      ),
    );
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
                            ProductModel cartModel = ProductModel(productObject.productMainCategory, productObject.productID, productObject.productImage, productObject.productName, productObject.productDescription, productObject.productPrice, productObject.productOldPrice, selectedQuantity, productObject.isFeatured, productObject.isRecommended);

                            dbUserCartReference.child(FirebaseAuth.instance.currentUser!.uid).child(productObject.productID).set(cartModel.toJson()).whenComplete(() {
                              Fluttertoast.showToast(msg: "Product added into cart successfully..!");
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

  checkForProductInCart(String productID) async {
    await dbUserCartReference.child(FirebaseAuth.instance.currentUser!.uid).once().then((value) {
      for (var element in value.snapshot.children) {
        if(element.key == productID) {
          debugPrint("${element.key} : ${productID}");
          setState(() {
            isAlreadyInCart = true;
          });
        }
      }
    });
  }

  Widget _buildFeaturedProducts(NewProductModel productModel, context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1,color:AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.menuDisplay,
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              icon: const Icon(
                                Icons.favorite_border,
                                //homeData.isFavourite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: AppColors.kAccentColor,
                              ),
                              onPressed: () {},
                            ),
                          )
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       isFavorite
                        //           ? const Icon(Icons.favorite, color: AppColors.kPrimaryColor))
                        //           : const Icon(Icons.favorite_border, color: AppColors.kPrimaryColor))
                        //     ]
                      )
                  ),
                  Center(
                    child: Hero(
                      tag: productModel.productID,
                      child: Container(
                        //height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(productModel.productImage), fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          productModel.productName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                              color: AppColors.kAccentLightColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0)),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                              "Rs. ${productModel.productPrice}",
                              style: const TextStyle(
                                  color: AppColors.kAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                          const SizedBox(width: 10.0),
                          Text(
                              "${double.parse(productModel.productPrice) + 550} (Rs.)",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.lightGreyLite,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0)),
                        ],
                      )
                  ),
                ],
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 5.0),
            //     child: Container(color: const Color(0xFFEBEBEB), height: 1.0)),
            // Padding(
            //   padding: EdgeInsets.only(left: 0.0, right: 0.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       if (!isAdded) ...[
            //         Icon(Icons.shopping_basket,
            //             color: AppColors.kPrimaryColor)),
            //         Text('Add to cart',
            //             style: TextStyle(
            //                 fontFamily: FontFamily.poppinsMedium,
            //                 color: AppColors.kPrimaryColor),
            //                 fontSize: 14.0)),
            //       ],
            //       // if (isAdded) ...[
            //       //   Icon(Icons.remove_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       //   Text('3',
            //       //       style: TextStyle(
            //       //           fontFamily: 'Varela',
            //       //           color: Color(0xFFD17E50),
            //       //           fontWeight: FontWeight.bold,
            //       //           fontSize: 12.0)),
            //       //   Icon(Icons.add_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       // ]
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedProducts(NewProductModel productModel, context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1,color:AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.menuDisplay,
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              icon: const Icon(
                                Icons.favorite_border,
                                //homeData.isFavourite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: AppColors.kAccentColor,
                              ),
                              onPressed: () {},
                            ),
                          )
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       isFavorite
                        //           ? const Icon(Icons.favorite, color: AppColors.kPrimaryColor))
                        //           : const Icon(Icons.favorite_border, color: AppColors.kPrimaryColor))
                        //     ]
                      )
                  ),
                  Center(
                    child: Hero(
                      tag: productModel.productID,
                      child: Container(
                        //height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(productModel.productName), fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          productModel.productName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                              color: AppColors.kAccentLightColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0)),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                              "Rs. ${productModel.productPrice}",
                              style: const TextStyle(
                                  color: AppColors.kAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                          const SizedBox(width: 10.0),
                          Text(
                              "${double.parse(productModel.productPrice) + 550} (Rs.)",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.lightGreyLite,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0)),
                        ],
                      )
                  ),
                ],
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 5.0),
            //     child: Container(color: const Color(0xFFEBEBEB), height: 1.0)),
            // Padding(
            //   padding: EdgeInsets.only(left: 0.0, right: 0.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       if (!isAdded) ...[
            //         Icon(Icons.shopping_basket,
            //             color: AppColors.kPrimaryColor)),
            //         Text('Add to cart',
            //             style: TextStyle(
            //                 fontFamily: FontFamily.poppinsMedium,
            //                 color: AppColors.kPrimaryColor),
            //                 fontSize: 14.0)),
            //       ],
            //       // if (isAdded) ...[
            //       //   Icon(Icons.remove_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       //   Text('3',
            //       //       style: TextStyle(
            //       //           fontFamily: 'Varela',
            //       //           color: Color(0xFFD17E50),
            //       //           fontWeight: FontWeight.bold,
            //       //           fontSize: 12.0)),
            //       //   Icon(Icons.add_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       // ]
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildCakeCard(HomeCategoriesModel homeData, context) {
    return InkWell(
      onTap: () {
        //Navigator.push(
            //context, MaterialPageRoute(builder: (context) => ProductDetails(categoriesModel: homeData)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1,color:AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.menuDisplay,
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                homeData.isFavourite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: AppColors.kAccentColor,
                              ),
                              onPressed: () {},
                            ),
                          )
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       isFavorite
                        //           ? const Icon(Icons.favorite, color: AppColors.kPrimaryColor))
                        //           : const Icon(Icons.favorite_border, color: AppColors.kPrimaryColor))
                        //     ]
                      )
                  ),
                  Center(
                    child: Hero(
                      tag: homeData.image,
                      child: Container(
                        //height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(homeData.image), fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          homeData.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                              color: AppColors.kAccentLightColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0)),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                              "Rs. ${homeData.price}",
                              style: const TextStyle(
                                  color: AppColors.kAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                          const SizedBox(width: 10.0),
                          Text(
                              "${homeData.price + 550} (Rs.)",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.lightGreyLite,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0)),
                        ],
                      )
                  ),
                ],
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 5.0),
            //     child: Container(color: const Color(0xFFEBEBEB), height: 1.0)),
            // Padding(
            //   padding: EdgeInsets.only(left: 0.0, right: 0.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       if (!isAdded) ...[
            //         Icon(Icons.shopping_basket,
            //             color: AppColors.kPrimaryColor)),
            //         Text('Add to cart',
            //             style: TextStyle(
            //                 fontFamily: FontFamily.poppinsMedium,
            //                 color: AppColors.kPrimaryColor),
            //                 fontSize: 14.0)),
            //       ],
            //       // if (isAdded) ...[
            //       //   Icon(Icons.remove_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       //   Text('3',
            //       //       style: TextStyle(
            //       //           fontFamily: 'Varela',
            //       //           color: Color(0xFFD17E50),
            //       //           fontWeight: FontWeight.bold,
            //       //           fontSize: 12.0)),
            //       //   Icon(Icons.add_circle_outline,
            //       //       color: Color(0xFFD17E50), size: 12.0),
            //       // ]
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Container buildCakeCategory(categoryName, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      // width: 150.0,
      height: double.infinity,
      decoration: isSelected
          ? BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(6),
      )
          : BoxDecoration(
        border: Border.all(
          color: Colors.red.shade400,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      //color: Colors.red,
      child: Center(
        child: Text(
          categoryName,
          // categoryList[index],
          maxLines: 1,
          style: TextStyle(color: isSelected ? AppColors.whiteColor : Colors.red.shade600, fontSize: 16),
          // style: TextStyle(color: Colors.red.shade600, fontSize: 16),
        ),
      ),
    );
  }

}
