import 'package:flutter/material.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/product_details_screen.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class AllRecommendedProducts extends StatefulWidget {

  AllRecommendedProducts({Key? key, required this.recommendedProductsList}) : super(key: key);

  List<NewProductModel> recommendedProductsList;

  @override
  State<AllRecommendedProducts> createState() => _AllRecommendedProductsState();
}

class _AllRecommendedProductsState extends State<AllRecommendedProducts> {

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
                itemCount: widget.recommendedProductsList.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext bContext, int position) {
                  NewProductModel productModel = widget.recommendedProductsList[position];
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                      },
                      child: itemsGridWidget(productModel.productImage, productModel.productName, double.parse(productModel.productPrice), double.parse(productModel.productPrice) + 380));
                  //return _buildRecommendedProducts(productModel, context);
                })
        ),
      ),
    );
  }

}
