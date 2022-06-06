import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/my_orders_controller.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/my_order_details.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  final MyOrdersController _myOrdersController = Get.put(MyOrdersController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myOrdersController.fetchMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("My Orders"),
      body: SafeArea(
        child: GetBuilder<MyOrdersController>(
          builder: (_) => _myOrdersController.isOrdersLoading
              ? defaultLoader(context)
              : !_myOrdersController.isOrdersLoading && _myOrdersController.myOrdersList.isNotEmpty
              ? Column(
            children: [
              SizedBox(
                height: 52.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _myOrdersController.ordersTabList.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    itemBuilder: (buildContext, position) {
                      String tabName = _myOrdersController.ordersTabList[position];
                      return GestureDetector(
                        onTap: (){
                          _myOrdersController.selectTabIndex(position);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0,
                                  color: AppColors.kAccentColor
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(500000)),
                              color: _myOrdersController.selectedIndex == position ? AppColors.kAccentColor : AppColors.whiteColor
                          ),
                          child: customTextWidget(tabName, 14.0, _myOrdersController.selectedIndex == position ? AppColors.whiteColor : AppColors.blackColor, FontWeight.bold),
                        ),
                      );
                    }),
              ),
              Expanded(
                  child: buildSelectedStatusOrders(
                      _myOrdersController.selectedIndex == 0 ? _myOrdersController.myOrdersList
                          : _myOrdersController.selectedIndex == 1 ? _myOrdersController.pendingOrdersList
                          : _myOrdersController.selectedIndex == 2 ? _myOrdersController.deliveredOrdersList
                          : _myOrdersController.receivedOrdersList
                  )
              ),
            ],
          )
              : emptyContainer(context, "No orders found."),
        ),
      ),
    );
  }

  buildSelectedStatusOrders(List<OrderModel> ordersList) {
    return ordersList.isNotEmpty
        ? ListView.builder(
        itemCount: ordersList.length,
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (bContext, index) {
          OrderModel orderModel = ordersList[index];
          return _buildOrders(orderModel, index);
        })
        : emptyContainer(context, "No orders found.");
  }

  Widget _buildOrders(OrderModel orderModel, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyOrderDetails(orderModel: orderModel)));
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: AppColors.smokeWhiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myTextSpanWidget("", "Order - #${index+1}"),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.date_range, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget(orderModel.orderDate, ""),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.firstOrder, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Ordered Item(s) : ", "${orderModel.noOfItems}"),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.payment_outlined, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Payment Method : ", orderModel.deliveryMethod),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Order Status : ", orderModel.orderStatus),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Payment Status : ", orderModel.paymentStatus),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.price_change, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Sub-Total : ", "Rs. ${orderModel.subTotal}"),
                ],
              ),
              const SizedBox(height: 2.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping, color: AppColors.kAccentColor),
                  const SizedBox(width: 10.0),
                  myTextSpanWidget("Shipping Fee : ", "Rs. ${orderModel.shippingFee}"),
                ],
              ),
              const SizedBox(height: 5.0),
              const Divider(color: AppColors.grey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    myTextWidget("Total : ", const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blackColor, fontSize: 20.0), 1),
                    Expanded(
                        child: Align(
                        alignment: Alignment.centerRight,
                        child: myTextWidget("Rs. ${orderModel.totalPrice}", const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: AppColors.kAccentColor), 1))),
                  ],
                ),
              ),
              const SizedBox(height: 5.0)
            ],
          ),
        ),
      ),
    );
  }

}
