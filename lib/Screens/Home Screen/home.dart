import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_bazar/Screens/Authentication/signin.dart';
import 'package:my_bazar/Screens/Checkout/cart_screen.dart';
import 'package:my_bazar/Screens/Home%20Screen/home_screen.dart';
import 'package:my_bazar/Screens/Profile/profile_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Orders/my_order.dart';
import '../Search/search_product_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int customerId = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> checkId() async {
    final prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId')!;
  }

  @override
  void initState() {
    checkId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const CartScreen().launch(context);
        },
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        isExtended: false,
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeScreen(),
          const SearchProductScreen(),
          customerId != 0 ? const MyOrders() : const SignIn(),
          customerId != 0 ? const ProfileScreen() : const SignIn(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        elevation: 6.0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        activeColor: kMainColor,
        inactiveColor: kGreyTextColor,
        // ignore: prefer_const_literals_to_create_immutables
        icons: [Icons.home, Icons.search, Icons.text_snippet_outlined, Icons.person_outline_rounded],
        activeIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
