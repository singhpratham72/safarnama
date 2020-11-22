import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:safarnama/tabs/home_tab.dart';
import 'package:safarnama/tabs/rent_tab.dart';
import 'package:safarnama/tabs/user_tab.dart';
import 'package:safarnama/tabs/wishlist_tab.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int selectedTab = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [HomeTab(), WishListTab(), RentTab(), UserTab()],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFEFEEEE).withOpacity(0.82),
                    spreadRadius: 5.0,
                    blurRadius: 7,
                    offset: Offset(0, -8))
              ]),
          child: BottomNavigationBar(
            currentIndex: selectedTab,
            onTap: (value) {
              setState(() {
                selectedTab = value;
                _pageController.jumpToPage(selectedTab);
                // _pageController.animateToPage(selectedTab,
                //     duration: Duration(milliseconds: 250),
                //     curve: Curves.easeOut);
              });
            },
            type: BottomNavigationBarType.fixed,
            iconSize: 40.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Theme.of(context).disabledColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 46.0,
                  ),
                  label: 'Home',
                  activeIcon: Icon(
                    Icons.home,
                    size: 46.0,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_outlined),
                  label: 'WishList',
                  activeIcon: Icon(Icons.favorite)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Rent',
                  activeIcon: Icon(Icons.shopping_cart)),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    size: 46.0,
                  ),
                  label: 'User',
                  activeIcon: Icon(
                    Icons.person,
                    size: 46.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
