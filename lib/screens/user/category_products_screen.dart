import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/user_products_controller.dart';
import 'package:online_cake_ordering/models/categories_model.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/product_details_screen.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class CategoryProducts extends StatefulWidget {

  final String cakeCategoryName;
  final String categoryImage;
  const CategoryProducts({Key? key, required this.cakeCategoryName, required this.categoryImage}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {

  final UserProductsController _userProductsController = Get.put(UserProductsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint(widget.cakeCategoryName);
    _userProductsController.fetchCakeCategoryAllProducts(widget.cakeCategoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteColor,
        appBar: customAppBar(widget.cakeCategoryName),
        body: SingleChildScrollView(
          child: GetBuilder<UserProductsController>(
              builder: (_) => _userProductsController.isCakeCategoryProductsLoading
                  ? Expanded(child: defaultLoader(context))
                  : !_userProductsController.isCakeCategoryProductsLoading &&
                  _userProductsController.cakeCategoryProductsList.isNotEmpty
                  ? Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      //width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.categoryImage,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      width: double.infinity,
                      child: GridView.builder(
                          itemCount: _userProductsController.cakeCategoryProductsList.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (BuildContext bContext, int position) {
                            NewProductModel productModel = _userProductsController.cakeCategoryProductsList[position];
                            return _buildCategoryProducts(productModel);
                          })
                  ),
                ],
              )
                  : Expanded(child: emptyContainer(context, "No ${widget.cakeCategoryName} category products found."))
          ),
        ),
    );
  }

  Widget _buildCakeCard(CategoryItems itemModel) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ProductDetails(categoriesModel: homeData)));
        },
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1, color: AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  itemModel.imageUrl,
                  fit: BoxFit.fill,
                ),
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
                          itemModel.title,
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
                              "Rs. ${itemModel.price}",
                              style: const TextStyle(
                                  color: AppColors.kAccentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                          const SizedBox(width: 10.0),
                          // Text(
                          //     "${homeData.price + 550} (Rs.)",
                          //     style: const TextStyle(
                          //         decoration: TextDecoration.lineThrough,
                          //         color: AppColors.lightGreyLite,
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 14.0)),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProducts(NewProductModel productModel) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1, color: AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  productModel.productImage,
                  fit: BoxFit.fill,
                ),
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
                          // Text(
                          //     "${homeData.price + 550} (Rs.)",
                          //     style: const TextStyle(
                          //         decoration: TextDecoration.lineThrough,
                          //         color: AppColors.lightGreyLite,
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 14.0)),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
