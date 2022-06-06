import 'package:flutter/material.dart';
import 'package:flutter_about_page/flutter_about_page.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  AboutPage ab = AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar("About Us"),
        body: ListView(
          children: [
            const SizedBox(height: 10.0),
            ab.setImage(ImageAssets.imagesLogoIcon),
            ab.addDescription("This Project is Designed & Developed by the Students of COMSATS University Islamabad, Vehari Campus"),
            ab.addWidget(
              const Text(
                "Version 1.0",
              ),
            ),
            ab.addGroup("Connect with us"),
            ab.addEmail("faisalarshadciit@gmail.com"),
            ab.addFacebook("faisalarshad850"),
            ab.addInstagram("faisalarshad850"),
            ab.addTwitter("faisalarshad850"),
            ab.addGithub("faisalarshadciit"),
            ab.addWebsite("https://www.fiverr.com/faisal_arshad86"),
            ab.addYoutube("UCeVMnSShP_Iviwkknt83cww"),
            ab.addPlayStore("com.tripline.radioapp"),
          ],
        )
    );
  }
}
