import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAccentColor,
      body: SafeArea(
        child: ContactUs(
            cardColor: Colors.white,
            textColor: AppColors.kAccentColor,
            taglineColor: AppColors.whiteColor,
            companyColor: AppColors.whiteColor,
            dividerColor: AppColors.whiteColor,
            logo: const NetworkImage(
              "https://pbs.twimg.com/profile_images/1240559121012625408/D2qvaJoR_400x400.jpg",
            ),
            companyName: 'Faisal Arshad',
            tagLine: 'Flutter Developer',
            email: 'faisalarshadciit@gmail.com',
            dividerThickness: 2,
            phoneNumber: '+923088649850',
            website: 'https://www.fiverr.com/faisal_arshad86/',
            githubUserName: 'faisalarshadciit',
            linkedinURL: 'https://www.linkedin.com/in/faisal-arshad-bb5ab1153/',
            twitterHandle: 'faisalarshad850',
            instagram: 'faisalarshad850',
            facebookHandle: 'faisalarshad850'),
      ),
      bottomNavigationBar: ContactUsBottomAppBar(
        companyName: 'COMSATS University',
        textColor: Colors.white,
        backgroundColor: AppColors.kAccentLightColor,
        email: 'faisalarshadciit@gmail.com',
        // textFont: 'Sail',
      ),
    );
  }
}
