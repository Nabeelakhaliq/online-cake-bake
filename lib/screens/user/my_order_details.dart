import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/my_orders_controller.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class MyOrderDetails extends StatefulWidget {
  const MyOrderDetails({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  _MyOrderDetailsState createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {

  final MyOrdersController _myOrdersController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myOrdersController.fetchOrderDetails(widget.orderModel.orderedProductsID, widget.orderModel.deliveryAddressID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Order Details"),
      body: SafeArea(
        child: GetBuilder<MyOrdersController>(
          builder: (_) => _myOrdersController.isOrdersDetailsLoading
              ? defaultLoader(context)
              : !_myOrdersController.isOrdersDetailsLoading && _myOrdersController.orderedProductsList.isNotEmpty
              ? ListView.builder(
              itemCount: _myOrdersController.orderedProductsList.length,
              padding: const EdgeInsets.all(10.0),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (bContext, index) {
                ProductModel productModel = _myOrdersController.orderedProductsList[index];
                return _buildOrderDetails(productModel);
              })
              : Expanded(child: emptyContainer(context, "Order details not found.")),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(ProductModel productModel) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppColors.smokeWhiteColor,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                child: Image.network(
                  productModel.productImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, Widget child, ImageChunkEvent? progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? (progress.cumulativeBytesLoaded / progress.expectedTotalBytes!) : null),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(productModel.productName != "" ? productModel.productName : "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.blackColor)),
                    const SizedBox(height: 5.0),
                    myTextWidget(
                        productModel.productDescription,
                        const TextStyle(fontSize: 14.0, color: AppColors.blackColor, fontWeight: FontWeight.normal),
                        3
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        myTextWidget(
                            "QTY: ${productModel.productStockQuantity}",
                            const TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                            1
                        ),
                        myTextWidget(
                            "Rs. ${productModel.productPrice}",
                            const TextStyle(fontSize: 14.0, color: AppColors.kAccentColor, fontWeight: FontWeight.bold),
                            1
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.greyColor),
                    myTextWidget(
                        "Total : Rs. ${double.parse(productModel.productPrice) * productModel.productStockQuantity}",
                        const TextStyle(fontSize: 14.0, color: AppColors.kAccentColor, fontWeight: FontWeight.bold),
                        1
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
