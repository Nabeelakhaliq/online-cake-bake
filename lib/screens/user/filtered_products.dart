import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_cake_ordering/controllers/user/filtered_products_controller.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/app_styles.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:online_cake_ordering/widgets/image_widgets.dart';
import 'package:online_cake_ordering/widgets/my_utils.dart';
import 'package:online_cake_ordering/widgets/stateless_widgets.dart';
// import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

double priceMinValue = 0.0;
double priceMaxValue = 10000.0;
int priceDivisions = priceMaxValue.round() - priceMinValue.round();
RangeValues myCurrentPriceRange = RangeValues(priceMinValue, priceMaxValue);

TextEditingController startValueEditingController = TextEditingController();
TextEditingController endValueEditingController = TextEditingController();

double _lowerValue = 0.0;
double _upperValue = 10000.0;
double _lowerValueFormatter = 20.0;
double _upperValueFormatter = 20.0;

class FilteredProducts extends StatefulWidget {
  const FilteredProducts({Key? key}) : super(key: key);

  @override
  State<FilteredProducts> createState() => _FilteredProductsState();
}

class _FilteredProductsState extends State<FilteredProducts> {

  final FilteredProductsController _filteredProductsController = Get.put(FilteredProductsController());
  bool checkAdvanceSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StringAssets.searchFieldController.clear();
    _filteredProductsController.fetchAllProducts();
    _filteredProductsController.fetchMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<FilteredProductsController>(
            builder: (_) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // StringAssets.homeSearchController.clear();
                            // StringAssets.searchFieldController.clear();
                            clearFilter();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  AppColors.blackColor.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                )
                              ],
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                              color: AppColors.whiteColor,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.kAccentColor,
                              size: 24.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  AppColors.blackColor.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                )
                              ],
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                              color: AppColors.whiteColor,
                            ),
                            child: Row(children: [
                              Expanded(
                                child: searchField(
                                    StringAssets.searchFieldController,
                                    "Search Products Here",
                                    false),
                              )
                            ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (checkAdvanceSearch) {
                                checkAdvanceSearch = false;
                              } else {
                                checkAdvanceSearch = true;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  AppColors.blackColor.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                )
                              ],
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                              color: AppColors.whiteColor,
                            ),
                            child: Icon(
                              checkAdvanceSearch
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down_outlined,
                              color: AppColors.kAccentColor,
                              size: 24.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Visibility(
                          visible: _filteredProductsController.isFilteredApplied.value,
                          child: GestureDetector(
                            onTap: () {
                              clearFilter();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    AppColors.blackColor.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 0),
                                  )
                                ],
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                                color: AppColors.whiteColor,
                              ),
                              child: const Icon(
                                Icons.clear_rounded,
                                color: AppColors.kAccentColor,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                !checkAdvanceSearch
                    ? Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.only(left:10.0,right:10.0),
                        child: Column(
                          children: [
                            myHorizontalDivider(),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  myVerticalDivider(),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          // if (manufacturesFilters.length != 0 ||
                                          //     specificationFilter.length !=
                                          //         0 ||
                                          //     catedFilterList.length != 0 ||
                                          //     myCurrentPriceRange.start != null) {
                                            filterBottomSheet();
                                          // } else {
                                          //   customAlert(context,
                                          //       'No Filters Available');
                                          // }
                                        },
                                        child: iconTextWidget(Icons.filter_alt_outlined, "Filters")),
                                  ),
                                  myVerticalDivider(),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          // availableSortOption?.isNotEmpty ??
                                          //     false
                                          //     ? sortingDialouge(context,
                                          //     availableSortOption)
                                          //     : customAlert(context,
                                          //     "TEXT_NO_SORTING".tr);
                                        },
                                        child: iconTextWidget(Icons.sort_rounded, "Sorting")),

                                  ),
                                  myVerticalDivider()
                                ],
                              ),
                            ),
                            myHorizontalDivider()
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
                Expanded(
                    child: _filteredProductsController.allProductsLoading
                        ? defaultLoader(context)
                        : !_filteredProductsController.allProductsLoading && _filteredProductsController.allProductsList.isNotEmpty
                        ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        width: double.infinity,
                        child: GridView.builder(
                            itemCount: _filteredProductsController.allProductsList.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              // crossAxisCount: 2,
                              // crossAxisSpacing: 10.0,
                              // mainAxisSpacing: 10.0,
                              childAspectRatio: 0.65,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext bContext, int position) {
                              NewProductModel productModel = _filteredProductsController.allProductsList[position];
                              return InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModel)));
                                  },
                                  //child: itemsGridWidget(productModel.productImage, productModel.productName, productModel.productPrice + 0, productModel.productPrice + 500));
                                  child: buildProductItems(productModel));
                              //return _buildFeaturedProducts(productModel, context);
                            })
                    )
                        : !_filteredProductsController.allProductsLoading && _filteredProductsController.allProductsList.isEmpty
                        ? Container(
                      child: emptyContainer(context, "No filtered products found."),
                    )
                        : Container()
                )
              ],
            )
        ),
      ),
    );
  }

  void filterBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topRight: Radius.circular(60.0),
            )),
        elevation: 5.0,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext buildContext) {
          return GetBuilder<FilteredProductsController>(
              builder: (_) => StatefulBuilder(
                  builder: (BuildContext statefulContext, StateSetter setState) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topRight: Radius.circular(60.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              margin: const EdgeInsets.only(top: 10),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50000000000.0)),
                                color: AppColors.kAccentColor,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20),
                                    child: myTextWidget(
                                        "Filters",
                                        const TextStyle(fontSize: 18.0,
                                            color: AppColors.kAccentColor,
                                            fontWeight: FontWeight.bold), 1
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            DropdownButtonHideUnderline(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  width: MediaQuery.of(context).size.width,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: AppColors.kAccentColor
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                      color: AppColors.whiteColor
                                  ),
                                  child: DropdownButton<String>(
                                    hint: const Text(
                                        "Select a Category",
                                        style: TextStyle(
                                            fontSize: 16.0, color: AppColors.kAccentColor),
                                        textAlign: TextAlign.left),
                                    value: _filteredProductsController.selectedCategory,
                                    isExpanded: true,
                                    isDense: false,
                                    dropdownColor: AppColors.whiteColor,
                                    icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                                    underline: Container(
                                      height: 1.0,
                                      color: AppColors.whiteColor,
                                    ),
                                    onChanged: (String? value) {
                                      // setState(() {
                                      //   selectedSubCategory = value!.categoryName;
                                      // });
                                      _filteredProductsController.changeCategory(value!);
                                    },
                                    items: _filteredProductsController.mainCategoriesList.map((String value) {
                                      return  DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          color: AppColors.whiteColor,
                                          child: Text(value, style: const TextStyle(
                                            fontSize: 16.0, color: AppColors.blackColor,
                                          ), textAlign: TextAlign.left),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10),
                              color: AppColors.whiteColor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: myCustomTextWidget(
                                              "Price",
                                              16.0,
                                              AppColors.kAccentColor,
                                              FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IntrinsicHeight(
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  MyInputField(
                                                    controller: _filteredProductsController.startPriceValueEditingController,
                                                    focusNode: _filteredProductsController.startPriceValueFocusNode,
                                                    obscureText: false,
                                                    textInputAction: TextInputAction.done,
                                                    autofocus: false,
                                                    keyboardType: TextInputType.number,
                                                    style: AppStyles.labelTextStyle,
                                                    cursorColor: AppColors.kAccentColor,
                                                    decoration: myInputDecoration(
                                                        "",
                                                        "",
                                                        false,
                                                        const Icon(
                                                          Icons.email,
                                                          color: AppColors.kAccentColor,
                                                          size: 24.0,
                                                        ),
                                                        true,
                                                        const EdgeInsets.symmetric(horizontal: 2.0, vertical: 7.0)
                                                    ),
                                                    // validator: (String? value) {
                                                    //   return null;
                                                    // },
                                                    onFieldSubmitted: (value){
                                                      try{
                                                        double start = double.parse(value!);
                                                        if(start >= 0 && start <= _filteredProductsController.maxPrice && start
                                                            <= _filteredProductsController.currentRangeValuesPrice.end)
                                                        {
                                                          RangeValues selectedValue = RangeValues(start, _filteredProductsController.currentRangeValuesPrice.end);
                                                          _filteredProductsController.setPrice(selectedValue);
                                                        }
                                                        else
                                                        {
                                                          _filteredProductsController.removeFocus();
                                                        }
                                                      }
                                                      catch(exception) {
                                                        _filteredProductsController.removeFocus();
                                                      }
                                                    },
                                                    onTap: (){
                                                      _filteredProductsController.startPriceValueEditingController.selection = TextSelection(baseOffset: 0, extentOffset: _filteredProductsController.startPriceValueEditingController.value.text.length);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: RangeSlider(
                                                values: _filteredProductsController.currentRangeValuesPrice,
                                                min: 0,
                                                max: _filteredProductsController.maxPrice.toDouble(),
                                                divisions: _filteredProductsController.maxPrice,
                                                activeColor: AppColors.kAccentColor,
                                                inactiveColor: AppColors.lightGreyColor,
                                                labels: RangeLabels(
                                                  _filteredProductsController.currentRangeValuesPrice.start.round().toString(),
                                                  _filteredProductsController.currentRangeValuesPrice.end.round().toString(),
                                                ),
                                                onChanged: (RangeValues values) {
                                                  _filteredProductsController.setPrice(values);
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: MyInputField(
                                                controller: _filteredProductsController.endPriceValueEditingController,
                                                focusNode: _filteredProductsController.endPriceValueFocusNode,
                                                obscureText: false,
                                                textInputAction: TextInputAction.done,
                                                autofocus: false,
                                                keyboardType: TextInputType.number,
                                                style: AppStyles.labelTextStyle,
                                                cursorColor: AppColors.kAccentColor,
                                                decoration: myInputDecoration(
                                                    "",
                                                    "",
                                                    false,
                                                    const Icon(
                                                      Icons.email,
                                                      color: AppColors.kAccentColor,
                                                      size: 24.0,
                                                    ),
                                                    true,
                                                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 7.0)
                                                ),
                                                // validator: (value) {
                                                //   return null;
                                                // },
                                                onFieldSubmitted: (value){
                                                  try{
                                                    double end = double.parse(value!);
                                                    if(end >= 0 && end <= _filteredProductsController.maxPrice && end >=
                                                        _filteredProductsController.currentRangeValuesPrice.start)
                                                    {
                                                      RangeValues selectedValue = RangeValues(_filteredProductsController.currentRangeValuesPrice.start, end);
                                                      _filteredProductsController.setPrice(selectedValue);
                                                    }
                                                    else{
                                                      _filteredProductsController.removeFocus();
                                                    }
                                                  } catch(exception){
                                                    _filteredProductsController.removeFocus();
                                                  }
                                                },
                                                onTap: (){
                                                  _filteredProductsController.endPriceValueEditingController.selection = TextSelection(baseOffset: 0, extentOffset: _filteredProductsController.endPriceValueEditingController.value.text.length);
                                                },
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                  // RangeSlider(
                                  //   values: myCurrentPriceRange,
                                  //   min: 0.0,
                                  //   max: 10000.0,
                                  //   // lowerValue: _lowerValue,
                                  //   // upperValue: _upperValue,
                                  //   divisions: 100,
                                  //   // showValueIndicator: true,
                                  //   // valueIndicatorMaxDecimals: 1,
                                  //   activeColor: AppColors.kAccentColor,
                                  //   inactiveColor: AppColors.kPrimaryLightColor,
                                  //   labels: RangeLabels(
                                  //     myCurrentPriceRange.start
                                  //         .round()
                                  //         .toString(),
                                  //     myCurrentPriceRange.end
                                  //         .round()
                                  //         .toString(),
                                  //   ),
                                  //   onChanged: (RangeValues values) {
                                  //     debugPrint(values);
                                  //     setState(() {
                                  //       myCurrentPriceRange = values;
                                  //       setRangeValues();
                                  //     });
                                  // },
                                  //   // onChanged: (double newLowerValue, double newUpperValue) {
                                  //   //   setState(() {
                                  //   //     _lowerValue = newLowerValue;
                                  //   //     _upperValue = newUpperValue;
                                  //   //   });
                                  //   // },
                                  //   // onChangeStart:
                                  //   //     (double startLowerValue, double startUpperValue) {
                                  //   //   print(
                                  //   //       'Started with values: $startLowerValue and $startUpperValue');
                                  //   // },
                                  //   // onChangeEnd: (double newLowerValue, double newUpperValue) {
                                  //   //   print(
                                  //   //       'Ended with values: $newLowerValue and $newUpperValue');
                                  //   // },
                                  // )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 15
                                      )
                                  ),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.kAccentColor),
                                  overlayColor: MaterialStateProperty.all(
                                      AppColors.kAccentLightColor),
                                  animationDuration:
                                  const Duration(milliseconds: 3, microseconds: 0),
                                ),
                                onPressed: () {
                                  _filteredProductsController.isFilteredApplied.value = true;
                                  Navigator.of(buildContext).pop();
                                  _filteredProductsController.fetchFilteredProducts(double.parse(_filteredProductsController.startPriceValueEditingController.text), double.parse(_filteredProductsController.endPriceValueEditingController.text));
                                  // searchcontroller.fetchSearchProducts(
                                  //     StringAssets.searchFieldController.text,
                                  //     CatesId,
                                  //     manufactureIdString,
                                  //     0,
                                  //     myCurrentPriceRange,
                                  //     orderby,
                                  //     0);
                                },
                                child: myCustomTextWidget(
                                    "Apply",
                                    14.0,
                                    AppColors.whiteColor,
                                    FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    );
                  })
          );
        });
  }

  Widget buildProductItems(NewProductModel productModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildImage(context, productModel.productImage),
              buildTitle(productModel.productName),
              buildRating(),
              buildPriceInfo(productModel, double.parse(productModel.productPrice.toString()), () {}),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.kAccentColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
              ),
              child: const Text("Shop Name", style: TextStyle(color: AppColors.whiteColor)),
            ),
          )
        ],
      ),
    );
  }

  void clearFilter() {
    _filteredProductsController.initRangeValues();
    _filteredProductsController.selectedCategory = null;
    setState(() {
      _filteredProductsController.isFilteredApplied.value = false;
      _filteredProductsController.fetchAllProducts();
    });
  }

}
