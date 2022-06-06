
class CategoryModel {
  late String categoryID;
  late String categoryName;
  late String categoryImage;

  CategoryModel(this.categoryID, this.categoryName, this.categoryImage);

  CategoryModel.fromJson(Map<dynamic, dynamic> json)
      : categoryID = json['categoryID'] as String,
        categoryName = json['categoryName'] as String,
        categoryImage = json['categoryImage'] as String;

  static CategoryModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return CategoryModel(
      value['categoryID'],
      value['categoryName'],
      value['categoryImage']
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'categoryID': categoryID,
    'categoryName': categoryName,
    'categoryImage': categoryImage
  };

}