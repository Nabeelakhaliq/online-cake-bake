import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/user_cart_controller.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/cart_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

import '../../config/size_config.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  DatabaseReference dbUserCartReference = FirebaseDatabase.instance.ref().child(StringAssets.userCartData);
  double totalPrice = 0;
  final UserCartController _userCartController = Get.put(UserCartController());

  @override
  void initState() {
    // TODO: implement initState

    if(isUserLoggedIn()) {
      _userCartController.fetchCartProducts(FirebaseAuth.instance.currentUser!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            applySpacer(),
            GetBuilder<UserCartController>(
                builder: (_) =>
                    _userCartController.isCartLoading
                        ? Expanded(child: defaultLoader(context))
                        : !_userCartController.isCartLoading && _userCartController.userCartList.isNotEmpty
                        ? Expanded(
                        child: ListView.builder(
                            itemCount: _userCartController.userCartList.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext bContext, int position) {
                              ProductModel cartData = _userCartController.userCartList[position];
                              return buildCartItem(cartData);
                            })
                    )
                        : Expanded(child: emptyContainer(context, "Your cart is empty."))
            )
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<UserCartController>(builder: (_) =>
          CheckoutCard(cartList: _userCartController.userCartList, totalPrice: _userCartController.totalPrice, noOfItems: _userCartController.userCartList.length)),
      //floatingActionButton: _paymentBtn(),
    );
  }

  Widget buildCartItem(ProductModel cartModel) {

    return Dismissible(
      key: Key(cartModel.productName.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Spacer(),
            SvgPicture.asset(ImageAssets.iconsTrash),
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          //demoCarts.removeAt(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 88,
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: imageWidget(cartModel.productImage),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _cardTitle(cartModel.productName),
                            _applySpacer(),
                            _cardQNTY(cartModel.productStockQuantity),
                            _applySpacer(),
                            _cartPrice(double.parse(cartModel.productPrice)),
                            _applySpacer(),
                            //productQuantityWidget(cartModel, cartModel.productStockQuantity)
                            _changeProductQuantityWidget(cartModel, cartModel.productStockQuantity)
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productQuantityWidget(ProductModel cartModel, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(4),
          ),
          onTap: () {
            debugPrint("press");
            // cart.decreaseItem(cartModel);
            // animationController.reset();
            // animationController.forward();
          },
          child: const Icon(Icons.remove_circle, color: AppColors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "$quantity",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(4),
          ),
          onTap: () {
            // cart.increaseItem(cartModel);
            // animationController.reset();
            // animationController.forward();
          },
          child: const Icon(Icons.add_circle, color: AppColors.white),
        ),
        InkWell(
          onTap: () {
            // cart.removeAllInCart(cartModel.food);
            // animationController.reset();
            // animationController.forward();
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(12),
          ),
          child: const Icon(Icons.delete_sweep, color: Colors.red),
        )
        // Flexible(
        //   flex: 3,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //
        //     ],
        //   )
        // ),
        // Flexible(
        //   flex: 1,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       Container(
        //         height: 45,
        //         width: 70,
        //         child: Text(
        //           '\$ ${cartModel.food.price}',
        //           style: titleStyle,
        //           textAlign: TextAlign.end,
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           cart.removeAllInCart(cartModel.food);
        //           animationController.reset();
        //           animationController.forward();
        //         },
        //         customBorder: roundedRectangle12,
        //         child: const Icon(Icons.delete_sweep, color: Colors.red),
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget buildCartCard(CartModel cartModel) {

    calculateTotal(cartModel);

    return Dismissible(
      key: Key(cartModel.name.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Spacer(),
            SvgPicture.asset(ImageAssets.iconsTrash),
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          //demoCarts.removeAt(index);
        });
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: AspectRatio(
                      aspectRatio: 0.8,
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: imageWidget(cartModel.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardTitle(cartModel.name),
                          _applySpacer(),
                          _cardQNTY(cartModel.quantity),
                          _applySpacer(),
                          _cartPrice(cartModel.price),
                          _applySpacer(),
                          _changeQuantityWidget(cartModel, cartModel.quantity)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  calculateTotal(CartModel cartModel) {
    totalPrice += (cartModel.price * cartModel.quantity);
  }

  Row _changeProductQuantityWidget(ProductModel cartModel, int quantity) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.kAccentColor,
          child: Center(
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.white),
                onPressed: () {
                  dbUserCartReference.child(FirebaseAuth.instance.currentUser!.uid).child(cartModel.productID).update({"productStockQuantity": cartModel.productStockQuantity + 1}).whenComplete(() {
                    debugPrint("Quantity updated (increased)");
                    _userCartController.fetchCartProducts(FirebaseAuth.instance.currentUser!.uid);
                  });
                },
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "$quantity",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        CircleAvatar(
          backgroundColor: AppColors.kAccentColor,
          child: Center(
              child: IconButton(
                icon: const Icon(Icons.remove, color: AppColors.white),
                onPressed: () {
                  if(cartModel.productStockQuantity - 1 > 0) {
                    dbUserCartReference.child(FirebaseAuth.instance.currentUser!.uid).child(cartModel.productID).update({"productStockQuantity": cartModel.productStockQuantity - 1}).whenComplete(() {
                      debugPrint("Quantity updated (decreased)");
                      _userCartController.fetchCartProducts(FirebaseAuth.instance.currentUser!.uid);
                    });
                  }
                },
              )
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  // cart.removeAllInCart(cartModel.food);
                  // animationController.reset();
                  // animationController.forward();
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(12),
                ),
                child: const Icon(Icons.delete_sweep, color: Colors.red),
              )
            ],
          ),
        )
      ],
    );
  }

  Row _changeQuantityWidget(CartModel cartModel, int quantity) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.kAccentColor,
          child: Center(
              child: IconButton(
                  icon: const Icon(Icons.add, color: AppColors.white),
                onPressed: () {
                    debugPrint("click");
                },
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "$quantity",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        CircleAvatar(
          backgroundColor: AppColors.kAccentColor,
          child: Center(
              child: IconButton(
                icon: const Icon(Icons.remove, color: AppColors.white),
                onPressed: () {
                  debugPrint("click");
                },
              )
          ),
        ),
      ],
    );
  }

  Widget _imageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 150,
      width: 100,
      alignment: Alignment.center,
      loadingBuilder: (context, child, loadingProgress) {
        final totalBytes = loadingProgress?.expectedTotalBytes;
        final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
        if (totalBytes != null && bytesLoaded != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.pink)
            ],
          );
        } else {
          return child;
        }
      },
      errorBuilder: (context, exception, stackTrack) => const Icon(Icons.error, color: Colors.red),
    );
    // return CachedNetworkImage(
    //   alignment: Alignment.center,
    //   imageUrl: imageUrl,
    //   height: 150,
    //   width: 100,
    //   imageBuilder: (context, imageProvider) => Container(
    //     clipBehavior: Clip.antiAlias,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(5.0),
    //       image: DecorationImage(
    //         image: imageProvider,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    //   //placeholder: (context, url) => CircularProgressIndicator(),
    //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress, color: AppColors.kAccentColor,)),
    //   errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.red),
    // );
  }

  Widget imageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      loadingBuilder: (context, child, loadingProgress) {
        final totalBytes = loadingProgress?.expectedTotalBytes;
        final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
        if (totalBytes != null && bytesLoaded != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.pink)
            ],
          );
        } else {
          return child;
        }
      },
      errorBuilder: (context, exception, stackTrack) => const Icon(Icons.error, color: Colors.red),
    );
    // return CachedNetworkImage(
    //   alignment: Alignment.center,
    //   imageUrl: imageUrl,
    //   height: 150,
    //   width: 100,
    //   imageBuilder: (context, imageProvider) => Container(
    //     clipBehavior: Clip.antiAlias,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(5.0),
    //       image: DecorationImage(
    //         image: imageProvider,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    //   //placeholder: (context, url) => CircularProgressIndicator(),
    //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress, color: AppColors.kAccentColor,)),
    //   errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.red),
    // );
  }

  Text _cardTitle(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      softWrap: true,
      style: textStyleBold(),
    );
  }

  Text _cartPrice(double price) {
    return Text(
      "Rs. : $price",
      style: textStyleBold(),
    );
  }

  Text _cardQNTY(int quantity) {
    return Text(
      "QTY: $quantity",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
    );
  }

  TextStyle textStyleBold() {
    return const TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  }

  SizedBox applySpacer() {
    return const SizedBox(
      height: 20,
    );
  }

  SizedBox _applySpacer() {
    return const SizedBox(
      height: 10,
    );
  }

  // double _calTotalPrice() {
  //   List<CartModel> items = getCartModel();
  //   double totalPrice = 0;
  //   for (var item in items) {
  //     totalPrice = totalPrice + item.price;
  //   }
  //   return totalPrice;
  // }

}
