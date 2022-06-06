
class NewProductModel {
  late String productMainCategory;
  late String productSubCategory;
  late String productID;
  late String productImage;
  late String productName;
  late String productDescription;
  late String productPrice;
  late String productOldPrice;
  late int productStockQuantity;
  late bool isFeatured;
  late bool isRecommended;

  NewProductModel(this.productMainCategory, this.productSubCategory, this.productID, this.productImage,
      this.productName, this.productDescription, this.productPrice, this.productOldPrice,
      this.productStockQuantity, this.isFeatured, this.isRecommended);

  NewProductModel.fromJson(Map<dynamic, dynamic> json)
      : productMainCategory = json['productMainCategory'] as String,
        productSubCategory = json['productSubCategory'] as String,
        productID = json['productID'] as String,
        productImage = json['productImage'] as String,
        productName = json['productName'] as String,
        productDescription = json['productDescription'] as String,
        productPrice = json['productPrice'] as String,
        productOldPrice = json['productOldPrice'] as String,
        productStockQuantity = json['productStockQuantity'] as int,
        isFeatured = json['isFeatured'] as bool,
        isRecommended = json['isRecommended'] as bool;

  static NewProductModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return NewProductModel(
      value['productMainCategory'],
      value['productSubCategory'],
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
    'productMainCategory': productMainCategory,
    'productSubCategory': productSubCategory,
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