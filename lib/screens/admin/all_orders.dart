import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/controllers/admin/orders_controller.dart';
import 'package:online_cake_ordering/models/order_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/my_order_details.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_cake_ordering/widgets/decorated_container_widgets.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key? key}) : super(key: key);

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  DatabaseReference dbAllOrdersRef = FirebaseDatabase.instance.ref().child(StringAssets.adminUsersOrdersData);
  final OrdersController _allOrdersController = Get.put(OrdersController());
  late List<String> orderStatusList;
  String selectedStatus = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderStatusList = ["Pending", "Delivered", "Received"];
    _allOrdersController.fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      appBar: customAppBar("Orders"),
      body: SafeArea(
        child: GetBuilder<OrdersController>(
          builder: (_) => _allOrdersController.isOrdersLoading
              ? defaultLoader(context)
              : !_allOrdersController.isOrdersLoading && _allOrdersController.allOrdersList.isNotEmpty
              ? Column(
                children: [
                  SizedBox(
                    height: 52.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _allOrdersController.ordersTabList.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                        itemBuilder: (buildContext, position) {
                          String tabName = _allOrdersController.ordersTabList[position];
                          return GestureDetector(
                            onTap: (){
                              _allOrdersController.selectTabIndex(position);
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
                                  color: _allOrdersController.selectedIndex == position ? AppColors.kAccentColor : AppColors.whiteColor
                              ),
                              child: customTextWidget(tabName, 14.0, _allOrdersController.selectedIndex == position ? AppColors.whiteColor : AppColors.blackColor, FontWeight.bold),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: buildSelectedStatusOrders(
                        _allOrdersController.selectedIndex == 0 ? _allOrdersController.allOrdersList
                            : _allOrdersController.selectedIndex == 1 ? _allOrdersController.pendingOrdersList
                            : _allOrdersController.selectedIndex == 2 ? _allOrdersController.deliveredOrdersList
                            : _allOrdersController.receivedOrdersList
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
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyOrderDetails(orderModel: orderModel)));
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
              const Divider(color: AppColors.grey),
              Padding(
                padding: EdgeInsets.all(
                  getProportionateScreenWidth(3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DecoratedContainerWidgets.decoratedIconTextContainer("Ordered Items", Icons.add_shopping_cart, AppColors.kAccentColor),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          //selectedStatus = orderModel.orderStatus;
                        });

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                  ),
                                    elevation: 5.0,
                                    backgroundColor: AppColors.whiteColor,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              myTextWidget("Select Order Status", const TextStyle(fontWeight: FontWeight.bold), 1),
                                              DropdownButton(
                                                elevation: 5,
                                                alignment: AlignmentDirectional.center,
                                                value: selectedStatus != "" ? selectedStatus : orderModel.orderStatus,
                                                underline: Container(
                                                  decoration: const ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    ),
                                                  ),
                                                ),
                                                hint: customTextWidget("Select Status", 14.0, Colors.black12, FontWeight.normal),
                                                items:  orderStatusList.map<DropdownMenuItem<String>>((status) {
                                                  return DropdownMenuItem(
                                                      value: status,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          customTextWidget(status, 14.0, Colors.black, FontWeight.bold)
                                                        ],
                                                      )
                                                  );
                                                }).toList(),
                                                onChanged: (String? val) {
                                                  setState(() {
                                                    selectedStatus = val!;
                                                    debugPrint(val);
                                                    //dbAllOrdersRef.child(orderModel.).update({"orderStatus": val});
                                                  });
                                                },
                                              ),
                                              SmallButton(
                                                text: "Update",
                                                textColor: AppColors.whiteColor,
                                                color: AppColors.kAccentColor,
                                                onPress: () async {
                                                  await _allOrdersController.updateOrderStatus(context, orderModel.customerID, orderModel.orderID, selectedStatus);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  );
                                });
                        });
                      },
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DecoratedContainerWidgets.decoratedIconTextContainer("Update Status", FontAwesomeIcons.firstOrder, AppColors.kAccentColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
