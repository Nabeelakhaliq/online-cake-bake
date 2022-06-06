import 'package:flutter/material.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/image_widgets.dart';

class AllFeaturedProducts extends StatefulWidget {
  AllFeaturedProducts({Key? key, required this.featuredProductsList}) : super(key: key);

  List<NewProductModel> featuredProductsList;
  @override
  State<AllFeaturedProducts> createState() => _AllFeaturedProductsState();
}

class _AllFeaturedProductsState extends State<AllFeaturedProducts> {

  late double defaultHeight, defaultWidth;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    defaultHeight = SizeConfig.screenHeight;
    defaultWidth = SizeConfig.screenWidth;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            width: double.infinity,
            child: GridView.builder(
                itemCount: widget.featuredProductsList.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.65,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext bContext, int position) {
                  NewProductModel productModel = widget.featuredProductsList[position];
                  return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                      },
                      child: buildFeaturedItems(productModel));
                })
        ),
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
                    // if(isUserLoggedIn()) {
                    //
                    //   await checkForProductInCart(productModel.productID);
                    //
                    //   if(isAlreadyInCart) {
                    //     Fluttertoast.showToast(msg: "Product already in cart!");
                    //   }
                    //   else {
                    //     settingModalBottomSheet(productModel);
                    //   }
                    // }
                    // else {
                    //   Fluttertoast.showToast(msg: "Please login to add item(s) in cart!");
                    // }
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

}
