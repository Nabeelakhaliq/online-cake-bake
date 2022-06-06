
class ProductModel {
  late String productCategory;
  late String productID;
  late String productImage;
  late String productName;
  late String productDescription;
  late String productPrice;
  late String productOldPrice;
  late int productStockQuantity;
  late bool isFeatured;
  late bool isRecommended;

  ProductModel(this.productCategory, this.productID, this.productImage,
      this.productName, this.productDescription, this.productPrice, this.productOldPrice,
      this.productStockQuantity, this.isFeatured, this.isRecommended);

  ProductModel.fromJson(Map<dynamic, dynamic> json)
      : productCategory = json['productCategory'] as String,
        productID = json['productID'] as String,
        productImage = json['productImage'] as String,
        productName = json['productName'] as String,
        productDescription = json['productDescription'] as String,
        productPrice = json['productPrice'] as String,
        productOldPrice = json['productOldPrice'] as String,
        productStockQuantity = json['productStockQuantity'] as int,
        isFeatured = json['isFeatured'] as bool,
        isRecommended = json['isRecommended'] as bool;

  static ProductModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return ProductModel(
      value['productCategory'],
      value['productID'],
      value['productImage'],
      value['productName'],
      value['productDescription'],
      value['productPrice'],
      value['productOldPrice'],
      value['productStockQuantity'],
      value['isFeatured'],
      value['isRecommended'],
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'productCategory': productCategory,
    'productID': productID,
    'productImage': productImage,
    'productName': productName,
    'productDescription': productDescription,
    'productPrice': productPrice,
    'productOldPrice': productOldPrice,
    'productStockQuantity': productStockQuantity,
    'isFeatured': isFeatured,
    'isRecommended': isRecommended
  };

}