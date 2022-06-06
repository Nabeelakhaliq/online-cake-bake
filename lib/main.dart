// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_cake_ordering/screens/user/my_splash_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cake Bake',
      home: const MySplashScreen(),
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        appBarTheme: const AppBarTheme(elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark),
        brightness: Brightness.light,
        textTheme: GoogleFonts.sansitaTextTheme(
          Theme.of(context).textTheme,
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryAccentColor),
        //brightness: Brightness.dark
        //appBarTheme: AppBarTheme(elevation: 2, brightness: Brightness.dark),
        //fontFamily: GoogleFonts.lato
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}