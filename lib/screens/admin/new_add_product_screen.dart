import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/controllers/admin/admin_products_controller.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_home.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewAddProduct extends StatefulWidget {
  const NewAddProduct({Key? key}) : super(key: key);

  @override
  _NewAddProductState createState() => _NewAddProductState();
}

class _NewAddProductState extends State<NewAddProduct>
    with AutomaticKeepAliveClientMixin<NewAddProduct> {

  @override
  bool get wantKeepAlive => true;

  late Reference firebaseStorage;
  late DatabaseReference categoryDbReference;
  late DatabaseReference databaseReference;
  final _addProductFormKey = GlobalKey<FormState>();
  TextEditingController productSubCategoryController = TextEditingController();
  TextEditingController productTitleController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  File? file;
  late String imageUrl;
  late String productId;
  bool isCake = false;
  bool isOtherCategory = false;
  bool uploadingProduct = false;
  bool isFeatured = false;
  bool isRecommended = false;
  List<String> mainCategories = ["Cakes", "Bakery Items", "Other"];
  String? selectedCategory;
  String? selectedSubCategory;

  final AdminProductsController _adminProductsController = Get.put(AdminProductsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // selectedCategory = mainCategories[0];
    getProductID();
    firebaseStorage = FirebaseStorage.instance.ref().child(StringAssets.productsStorageReference);
    categoryDbReference = FirebaseDatabase.instance.ref().child(StringAssets.mainCategories);
    databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.productsData);

    _adminProductsController.fetchMainCategories();
    _adminProductsController.fetchCakeCategories();
  }

  @override
  Widget build(BuildContext context) {

    return file == null
        ? displayAdminHomeScreen()
        : displayUploadFormScreen();
  }

  // region Select Image Display
  displayAdminHomeScreen() {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: customAppBar("Add Product"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two_outlined,
              color: AppColors.kAccentColor,
              size: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: const Text(
                  "Upload Your Product Image",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // endregion

  // region Image Selection
  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: const Text(
              "Chose Image",
              style:
              TextStyle(color: AppColors.kAccentColor, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera",
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from Gallery",
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red[600]),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {

    Navigator.pop(context);
    // ignore: deprecated_member_use
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 680,
        maxWidth: 970);

    setState(() {
      file = File(imageFile!.path);
    });
  }

  pickPhotoFromGallery() async {

    Navigator.pop(context);
    // ignore: deprecated_member_use
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery);

    setState(() {
      file = File(imageFile!.path);
    });
  }
  // endregion

  // region Display Image & TextFields
  displayUploadFormScreen() {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Product",
        ),
        backgroundColor: AppColors.kAccentColor,
        actions: [
          Visibility(
            visible: !uploadingProduct,
            child: FlatButton(
              child: const Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: uploadCakeProduct,
              //onPressed: uploading ? null : () => clearFormInfo(),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploadingProduct ? linearProgress() : const Text(""),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width - 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16.0/9.0,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          Form(
            key: _addProductFormKey,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.perm_device_info, color: Colors.pink),
                  title: DropdownButtonHideUnderline(
                      child: Container(
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
                          hint:  const Text(
                              "Select a Category",
                              style: TextStyle(
                                  fontSize: 16.0, color: AppColors.kAccentColor),
                              textAlign: TextAlign.left),
                          value: selectedCategory,
                          isExpanded: true,
                          isDense: false,
                          dropdownColor: AppColors.whiteColor,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                          underline: Container(
                            height: 1.0,
                            color: AppColors.whiteColor,
                          ),
                          onChanged: (String? value) {
                            debugPrint(value);
                            setState(() {
                              if(value == mainCategories[0]) {
                                isCake = true;
                              }
                              else {
                                selectedSubCategory = "";
                                isCake = false;
                              }
                            });

                            setState(() {
                              if(value == mainCategories[2]) {
                                isOtherCategory = true;
                              }
                              else {
                                isOtherCategory = false;
                              }
                            });

                            selectedCategory = value!;
                          },
                          items: mainCategories.map((String value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                color: AppColors.whiteColor,
                                child: Text(value,
                                    style: const TextStyle(
                                      fontSize: 16.0, color: AppColors.blackColor
                                    ),
                                    textAlign: TextAlign.left
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                  ),
                ),
                const Divider(
                  color: Colors.pink,
                ),
                Visibility(
                  visible: isCake,
                  child: GetBuilder<AdminProductsController>(
                      builder: (_) =>
                      _adminProductsController.isCakeCategoriesLoading
                          ? Container()
                          : !_adminProductsController.isCakeCategoriesLoading &&
                          _adminProductsController.cakeCategoriesList.isNotEmpty
                          ? ListTile(
                        leading: const Icon(Icons.perm_device_info, color: Colors.pink),
                        title: DropdownButtonHideUnderline(
                            child: Container(
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
                              child: DropdownButton<CategoryModel>(
                                hint: const Text(
                                    "Select Cake Category",
                                    style: TextStyle(
                                        fontSize: 16.0, color: AppColors.kAccentColor),
                                    textAlign: TextAlign.left),
                                value: _adminProductsController.selectedCakeCategory,
                                isExpanded: true,
                                isDense: false,
                                dropdownColor: AppColors.whiteColor,
                                icon: const Icon(Icons.keyboard_arrow_down, size: 24.0, color: AppColors.blackColor,),
                                underline: Container(
                                  height: 1.0,
                                  color: AppColors.whiteColor,
                                ),
                                onChanged: (CategoryModel? value) {
                                  setState(() {
                                    selectedSubCategory = value!.categoryName;
                                  });
                                  _adminProductsController.changeCakeCategory(value!);
                                },
                                items: _adminProductsController.cakeCategoriesList.map((CategoryModel value) {
                                  return  DropdownMenuItem<CategoryModel>(
                                    value: value,
                                    child: Container(
                                      color: AppColors.whiteColor,
                                      child: Text(value.categoryName, style: const TextStyle(
                                        fontSize: 16.0, color: AppColors.blackColor,
                                      ), textAlign: TextAlign.left),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                        ),
                      )
                          : Container()
                  ),
                ),
                Visibility(
                  visible: isOtherCategory,
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.pink,
                      ),
                      DefaultFormField(
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textEditingController: productSubCategoryController,
                        hintText: "Other Category Name",
                        nullError: "Other Category Name Required",
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.pink,
                ),
                DefaultFormField(
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textEditingController: productTitleController,
                  hintText: "Product Title",
                  nullError: "Product Name Required",
                ),
                const Divider(
                  color: Colors.pink,
                ),
                DefaultFormField(
                  inputAction: TextInputAction.next,
                  inputType: const TextInputType.numberWithOptions(decimal: true),
                  textCapitalization: TextCapitalization.none,
                  textEditingController: productPriceController,
                  hintText: "Product Price",
                  nullError: "Product Price Required",
                ),
                const Divider(
                  color: AppColors.kAccentColor,
                ),
                DefaultFormField(
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textEditingController: productDescriptionController,
                  hintText: "Product Description",
                  nullError: "Product Description Required",
                ),
                const Divider(
                  color: Colors.pink,
                ),
                DefaultFormField(
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  textEditingController: productQuantityController,
                  hintText: "Product Quantity(in Stock)",
                  nullError: "Product Quantity Required",
                ),
                const Divider(
                  color: Colors.pink,
                ),
                CheckboxListTile(
                    title: const Text("Marked as Featured"),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.kAccentColor,
                    value: isFeatured,
                    onChanged: (bool? val) {
                      setState(() {
                        isFeatured = !isFeatured;
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Marked as Recommended"),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.kAccentColor,
                    value: isRecommended,
                    onChanged: (bool? val) {
                      setState(() {
                        isRecommended = !isRecommended;
                      });
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
  // endregion

  uploadCakeProduct() async {

    if (_addProductFormKey.currentState!.validate()) {

      String fileName = getFileName(file!);
      debugPrint("fileName $fileName");

      if (file != null)
      {
        if(selectedCategory != null && selectedCategory != "")
        {
          if(isCake)
          {
            if(_adminProductsController.selectedCakeCategory != null)
            {
              debugPrint("Cake");
              startAddingProduct(fileName);
            }
            else
            {
              Fluttertoast.showToast(msg: "Please! Select cake sub category!");
            }
          }
          else if(isOtherCategory)
          {
            selectedCategory = productSubCategoryController.text;
            startAddingProduct(fileName);
            debugPrint("Other $selectedSubCategory");
          }
          else
          {
            startAddingProduct(fileName);
          }

          checkForMainCategory(selectedCategory);
        }
        else
        {
          Fluttertoast.showToast(msg: "Please! Select a category!");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Please! Chose image first!");
        clearFormInfo();
      }
    }
  }

  getFileName(File mFile) {
    String fileName = mFile.path.split('/').last;

    return fileName;
  }

  Future<void> startAddingProduct(String fileName) async {
    setState(() {
      uploadingProduct = true;
    });

    var snapshot = await firebaseStorage.child('/$fileName')
        .putFile(file!).whenComplete(() {
      debugPrint("Uploaded...!");
    });

    await snapshot.ref.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
        debugPrint(imageUrl);
      });
    });

    saveProduct();
  }

  saveProduct() {

    NewProductModel newProductModel = NewProductModel(
        selectedCategory!, selectedSubCategory!, productId, imageUrl, productTitleController.text,
        productDescriptionController.text, double.parse(productPriceController.text).toStringAsFixed(2),
        double.parse("0").toStringAsFixed(2), int.parse(productQuantityController.text),
        isFeatured, isRecommended);

    databaseReference.push().set(newProductModel.toJson()).whenComplete(() {
      setState(() {
        uploadingProduct = false;
        _showSuccessAlert(context);
      });
    });
  }

  _showSuccessAlert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
          color: AppColors.kAccentColor,
          fontWeight: FontWeight.bold
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Add Product",
      desc: "Product has been added successfully. Do you want to add another?",
      buttons: [
        DialogButton(
          child: const Text(
            "NO",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHome()));
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: const Text(
            "YES",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            clearFormInfo();
            Navigator.pop(context);
          },
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  clearFormInfo() {
    setState(() {
      file = null;
      isFeatured = false;
      isRecommended = false;
      productTitleController.clear();
      productPriceController.clear();
      productDescriptionController.clear();
      productQuantityController.clear();
      getProductID();
      _adminProductsController.fetchMainCategories();
      // selectedCategory = "";
      _adminProductsController.selectedCakeCategory = null;
      //_adminProductsController.selectedCategory = null;
    });
  }

  void getProductID() {
    setState(() {
      productId = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  bool isPresent(String categoryName) {
    return _adminProductsController.mainCategoriesList.contains(categoryName);
  }

  void checkForMainCategory(String? categoryName) {

    bool isExists = isPresent(categoryName!);

    if(!isExists) {
      categoryDbReference.push().set({'productMainCategory': categoryName})
          .whenComplete(() {
        debugPrint("Saved...!");
      });
    }
    else {
      debugPrint("Already Exits...!");
    }
  }
}
