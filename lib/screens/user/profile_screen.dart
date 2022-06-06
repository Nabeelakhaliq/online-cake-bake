import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/methods/methods.dart';
import 'package:online_cake_ordering/models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? nameTitle = "Mr Flutter";
  String? emailTitle = "A flutter developer";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSpacer(),
            // Container(
            //   padding: EdgeInsets.all(10),
            //   child: buildActionbar(
            //     context,
            //     "Profile",
            //     "User Profile",
            //   ),
            // ),
            _buildSpacer(),
            _buildClipOval(),
            const SizedBox(height: 20),
            Text(
              nameTitle!,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              emailTitle!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: double.minPositive,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: getUserOptions().length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: getUserOptions()[index].icon,
                        // onTap: () => showSnackBar(
                        //     context, getUserOptions()[index].title),
                        title: Text(
                          getUserOptions()[index].title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox _buildSpacer() => const SizedBox(height: 20);

  ClipOval _buildClipOval() {
    return ClipOval(
      child: Image.network(
        "https://pbs.twimg.com/profile_images/1240559121012625408/D2qvaJoR_400x400.jpg",
        height: 150.0,
        width: 150.0,
      ),
    );
  }

  void getUserData() {

    debugPrint("isUserLoggedIn ${isUserLoggedIn()}");
    if(isUserLoggedIn()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      setState(() {
        emailTitle = firebaseUser?.email;
        if(firebaseUser!.displayName != null) {
          nameTitle = firebaseUser.displayName;
        }
      });
    }
  }
}
