import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/user_products_controller.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/custom_cake_ordering.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'category_products_screen.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  final UserProductsController _userProductsController = Get.put(UserProductsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProductsController.fetchCakeCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: GetBuilder<UserProductsController>(
              builder: (_) => _userProductsController.isCakeCategoriesLoading
                  ? Expanded(child: defaultLoader(context))
                  : !_userProductsController.isCakeCategoriesLoading &&
                  _userProductsController.cakeCategoriesList.isNotEmpty
                  ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  width: double.infinity,
                  child: GridView.builder(
                      itemCount: _userProductsController.cakeCategoriesList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext bContext, int position) {
                        CategoryModel categoryModel = _userProductsController.cakeCategoriesList[position];
                        return _buildCategoryDesign(categoryModel);
                      })
              )
                  : emptyContainer(context, "No category found.")
          )
      ),
    );
  }

  Widget _buildCategoryDesign(CategoryModel categoryModel) {
    return InkWell(
      onTap: () {
        if(categoryModel.categoryName == "Custom Design") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCakeOrdering()));
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProducts(cakeCategoryName: categoryModel.categoryName, categoryImage: categoryModel.categoryImage)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1,color:AppColors.blackColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
            ],
            color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)
                    ),
                    image: DecorationImage(
                      image: NetworkImage(categoryModel.categoryImage),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  categoryModel.categoryName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                      color: AppColors.kAccentColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0)
              ),
            ),
          ],
        ),
      ),
    );
  }

}
