import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/models/slider_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/admin/admin_home.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UploadSlider extends StatefulWidget {
  const UploadSlider({Key? key}) : super(key: key);

  @override
  _UploadSliderState createState() => _UploadSliderState();
}

class _UploadSliderState extends State<UploadSlider>
    with AutomaticKeepAliveClientMixin<UploadSlider> {

  @override
  bool get wantKeepAlive => true;

  late Reference firebaseStorage;
  late DatabaseReference databaseReference;
  File? file;
  late String imageUrl;
  String sliderId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploadingSlider = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseStorage = FirebaseStorage.instance.ref().child(StringAssets.sliderStorageReference);
    databaseReference = FirebaseDatabase.instance.ref().child(StringAssets.slidersData);
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
      appBar: customAppBar("Upload Deal"),
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
                  "Upload Your Deal",
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
            "Upload Deal"
        ),
        backgroundColor: AppColors.kAccentColor,
        actions: [
          Visibility(
            visible: !uploadingSlider,
            child: FlatButton(
              child: const Text(
                "Upload",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              //onPressed: checkForCategoryExistence,
              onPressed: uploadDeal,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploadingSlider ? linearProgress() : const Text(""),
          Center(
            child: SizedBox(
              height: 300,
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
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
          ),
        ],
      ),
    );
  }
  // endregion

  clearFormInfo() {
    setState(() {
      file = null;
    });
  }

  uploadDeal() async {

    if (file != null)
    {
      String fileName = getFileName(file!);
      debugPrint("fileName $fileName");

      setState(() {
        uploadingSlider = true;
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

      saveSlider();
    }
    else
    {
      Fluttertoast.showToast(msg: "Please! Chose image first!");
      clearFormInfo();
    }
  }

  saveSlider() {
    SliderModel sliderModel = SliderModel(sliderId, imageUrl);

    databaseReference.push().set(sliderModel.toJson()).whenComplete(() {
      setState(() {
        uploadingSlider = false;
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
      title: "Deal Added",
      desc: "Deal has been added successfully. Do you want to add another?",
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
