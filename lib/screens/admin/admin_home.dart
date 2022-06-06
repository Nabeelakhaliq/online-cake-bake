import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/controllers/admin/admin_home_controller.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/widgets/admin_drawer_widget.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/top_promo_slider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  final AdminHomeController _adminHomeController = Get.put(AdminHomeController());

  late DatabaseReference databaseReference;
  List<CategoryModel> dataList = List.empty(growable: true);
  late double defaultHeight, defaultWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adminHomeController.fetchAllProducts();
    _adminHomeController.fetchAllBanners();
    databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.categoriesData);
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    defaultHeight = SizeConfig.screenHeight;
    defaultWidth = SizeConfig.screenWidth;

    return Scaffold(
      appBar: customAppBar("Admin Home"),
      drawer: const CustomAdminDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<AdminHomeController>(
                  builder: (_) => _adminHomeController.isSlidersLoading
                      ? Container()
                      : !_adminHomeController.isSlidersLoading && _adminHomeController.imagesList.isNotEmpty
                      ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                      child: TopPromoSlider(defaultHeight * 0.23, defaultWidth, _adminHomeController.imagesList))
                      : Container()
              ),
              GetBuilder<AdminHomeController>(
                builder: (_) => _adminHomeController.isProductsLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.pink))
                    : !_adminHomeController.isProductsLoading && _adminHomeController.productsList.isNotEmpty
                    ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: _adminHomeController.productsList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext bContext, int position) {
                        NewProductModel newProductModel = _adminHomeController.productsList[position];
                        return _buildProductsDesign(newProductModel);
                      })
                )
                    : Container()
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildProductsDesign(NewProductModel productModel) {
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
