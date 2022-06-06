
class OrderModel {

  late String orderDate;
  late String customerID;
  late String orderedProductsID;
  late String deliveryAddressID;
  late String orderID;
  late String orderStatus;
  late String paymentStatus;
  late int noOfItems;
  late String subTotal;
  late String shippingFee;
  late String totalPrice;
  late String deliveryMethod;
  late String paymentSSUrl;

  OrderModel(this.orderDate, this.customerID, this.orderedProductsID, this.orderID,
      this.deliveryAddressID, this.orderStatus, this.paymentStatus, this.noOfItems, this.subTotal,
      this.shippingFee, this.totalPrice, this.deliveryMethod, this.paymentSSUrl);

  OrderModel.fromJson(Map<dynamic, dynamic> json)
      : orderDate = json['orderDate'] as String,
        customerID = json['customerID'] as String,
        orderedProductsID = json['orderedProductsID'] as String,
        deliveryAddressID = json['deliveryAddressID'] as String,
        orderID = json['orderID'] as String,
        orderStatus = json['orderStatus'] as String,
        paymentStatus = json['paymentStatus'] as String,
        noOfItems = json['noOfItems'] as int,
        subTotal = json['subTotal'] as String,
        shippingFee = json['shippingFee'] as String,
        totalPrice = json['totalPrice'] as String,
        deliveryMethod = json['deliveryMethod'] as String,
        paymentSSUrl = json['paymentSSUrl'] as String;

  static OrderModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return OrderModel(
      value['orderDate'],
      value['customerID'],
      value['orderedProductsID'],
      value['deliveryAddressID'],
      value['orderID'],
      value['orderStatus'],
      value['paymentStatus'],
      value['noOfItems'],
      value['subTotal'],
      value['shippingFee'],
      value['totalPrice'],
      value['deliveryMethod'],
      value['paymentSSUrl'],
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'orderDate': orderDate,
    'customerID': customerID,
    'orderedProductsID': orderedProductsID,
    'deliveryAddressID': deliveryAddressID,
    'orderID': orderID,
    'orderStatus': orderStatus,
    'paymentStatus': paymentStatus,
    'noOfItems': noOfItems,
    'subTotal': subTotal,
    'shippingFee': shippingFee,
    'totalPrice': totalPrice,
    'deliveryMethod': deliveryMethod,
    'paymentSSUrl': paymentSSUrl
  };

}