import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/models/category_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_home.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_cake_ordering/widgets/forms_widgets/form_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory>
    with AutomaticKeepAliveClientMixin<AddCategory> {

  @override
  bool get wantKeepAlive => true;

  late Reference firebaseStorage;
  late DatabaseReference databaseReference;
  final _addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryTitleController = TextEditingController();
  File? file;
  late String imageUrl;
  String categoryId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploadingCategory = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseStorage = FirebaseStorage.instance.ref().child(StringAssets.categoryStorageReference);
    databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.categoriesData);
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
      appBar: customAppBar("Add Category"),
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
                  "Upload Your Category",
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
          "Add Category",
        ),
        backgroundColor: AppColors.kAccentColor,
        actions: [
          Visibility(
            visible: !uploadingCategory,
            child: FlatButton(
              child: const Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              //onPressed: checkForCategoryExistence,
              onPressed: uploadCategory,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploadingCategory ? linearProgress() : const Text(""),
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
            key: _addCategoryFormKey,
            child: Column(
              children: [
                DefaultFormField(
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textEditingController: categoryTitleController,
                  hintText: "Category Name",
                  nullError: "Category Name Required",
                ),
                const Divider(
                  color: AppColors.kAccentColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // endregion

  clearFormInfo() {
    setState(() {
      file = null;
      categoryTitleController.clear();
    });
  }

  Future<bool> checkForCategoryExistence() async {
    bool isExists = false;
    DatabaseReference dbCategoriesReference = FirebaseDatabase.instance.ref().child(StringAssets.categoriesData);
    List<CategoryModel> categoryList = List.empty(growable: true);

    await dbCategoriesReference.once().then((value) {
      for (var element in value.snapshot.children) {
        final Map value = element.value as Map;
        CategoryModel? categoryModel = CategoryModel.fromMap(value);
        categoryList.add(categoryModel!);
      }
    });

    isExists = categoryList.any((element) => element.categoryName == categoryTitleController.text.trim());

    debugPrint(isExists.toString());

    return isExists;
  }

  uploadCategory() async {

    if (_addCategoryFormKey.currentState!.validate()) {

      String fileName = getFileName(file!);
      debugPrint("fileName $fileName");

      if (file != null)
      {
        setState(() {
          uploadingCategory = true;
        });

        if(!await checkForCategoryExistence())
        {
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

          saveCategory();
        }
        else {
          setState(() {
            uploadingCategory = false;
          });
          Fluttertoast.showToast(msg: "Category already exists!");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Please! Chose image first!");
        clearFormInfo();
      }

    }
  }

  saveCategory() {
    CategoryModel categoryModel = CategoryModel(categoryId, categoryTitleController.text, imageUrl);

    databaseReference.push().set(categoryModel.toJson()).whenComplete(() {
      setState(() {
        uploadingCategory = false;
        _showSuccessAlert(context);
      });
    });
  }

  getFileName(File mFile) {
    String fileName = mFile.path.split('/').last;

    return fileName;
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
      title: "Add Category",
      desc: "Category has been added successfully. Do you want to add another?",
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

}
