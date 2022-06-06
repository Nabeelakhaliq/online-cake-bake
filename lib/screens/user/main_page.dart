import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/screens/user/cart_screen.dart';
import 'package:online_cake_ordering/screens/user/filtered_products.dart';
import 'package:online_cake_ordering/widgets/drawer_widget.dart';

import 'category_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  bool _foled = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  _onItemTapped(int index) {
    setState(() {
      if (kDebugMode) {
        debugPrint(index.toString());
      }
      widget.selectedIndex = index;
    });
  }

  List<String> titles = ["Cake Bake", "Categories", "Cart", "Profile"];
  List<Widget> bottomNavList = <Widget>[
    const HomePage(),
    const CategoryPage(),
    const CartPage(),
    const ProfilePage(),
    //DashboardBody()
  ];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    controller = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titles[widget.selectedIndex],
        ),
        backgroundColor: AppColors.kAccentLightColor,
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: _foled ? 56 : 250,
            height: 56,
            decoration: !_foled
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(_foled ? 30.0 : 20.0),
                    color: Colors.white,
                    boxShadow: kElevationToShadow[6],
                  )
                : null,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: !_foled
                        ? TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  color: Colors.pink[700],
                                  fontWeight: FontWeight.w600),
                              border: InputBorder.none,
                            ),
                          )
                        : null,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 400),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(_foled ? 32 : 0),
                        topRight: const Radius.circular(
                          32,
                        ),
                        bottomLeft: Radius.circular(_foled ? 32 : 0),
                        bottomRight: const Radius.circular(
                          32,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          _foled ? Icons.search : Icons.close,
                          color:
                              _foled ? AppColors.whiteColor : Colors.pink[700],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const FilteredProducts()));
                          // _foled = !_foled;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: bottomNavList.elementAt(widget.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.kAccentColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: widget.selectedIndex,
        onTap: (value) {
          _onItemTapped(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category_rounded,
            ),
            label: 'Cake Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.shopping_cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
            ),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
