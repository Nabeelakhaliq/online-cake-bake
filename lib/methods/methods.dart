import 'package:firebase_auth/firebase_auth.dart';

bool isUserLoggedIn() {
  bool isLoggedIn = false;

  if (FirebaseAuth.instance.currentUser != null) {
    // signed in
    isLoggedIn = true;
  }
  else {
    isLoggedIn = false;
  }

  return isLoggedIn;
}

String getUserID() {

  return FirebaseAuth.instance.currentUser!.uid;
}