import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/constants.dart';
import 'package:safarnama/models/user.dart' as userModel;
import 'package:safarnama/tabs/home_tab.dart';
import 'package:safarnama/tabs/rent_tab.dart';
import 'package:safarnama/tabs/user_tab.dart';
import 'package:safarnama/tabs/saved_tab.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int selectedTab = 0;
  PageController _pageController = PageController(initialPage: 0);
  Position _position;
  Future<void> getLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
  }

  @override
  void initState() {
    super.initState();
    getLocation().whenComplete(() {
      setState(() {});
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _getLocation();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel.User>(context);
    user.updatePosition(_position);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: selectedTab != 3 ? 64.0 : 0.0),
          child: Column(
            children: [
              // HomeTab Header
              if (selectedTab == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${user.name}.',
                              style: greyText.copyWith(fontSize: 20.0),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'Find your ',
                                  style: headingText,
                                  children: [
                                    TextSpan(
                                        text: 'trek',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                  ]),
                            ),
                          ]),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 3;
                            _pageController.jumpToPage(selectedTab);
                          });
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(FirebaseAuth
                                        .instance.currentUser.photoURL ??
                                    'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/users%2Fanonymous.jpg?alt=media&token=3a3df200-04f6-43d3-87eb-a33fa4c3b7b4'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: Theme.of(context).accentColor),
                        ),
                      )
                    ],
                  ),
                ),
              // SavedTab Header
              if (selectedTab == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Saved ',
                            style: headingText.copyWith(fontSize: 32.0),
                            children: [
                              TextSpan(
                                  text: 'treks',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor))
                            ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 3;
                            _pageController.jumpToPage(selectedTab);
                          });
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(FirebaseAuth
                                        .instance.currentUser.photoURL ??
                                    'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/users%2Fanonymous.jpg?alt=media&token=3a3df200-04f6-43d3-87eb-a33fa4c3b7b4'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: Theme.of(context).accentColor),
                        ),
                      )
                    ],
                  ),
                ),
              // RentTab Header
              if (selectedTab == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Rent your ',
                            style: headingText.copyWith(fontSize: 32.0),
                            children: [
                              TextSpan(
                                  text: 'gear',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor))
                            ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 3;
                            _pageController.jumpToPage(selectedTab);
                          });
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(FirebaseAuth
                                        .instance.currentUser.photoURL ??
                                    'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/users%2Fanonymous.jpg?alt=media&token=3a3df200-04f6-43d3-87eb-a33fa4c3b7b4'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: Theme.of(context).accentColor),
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [HomeTab(), SavedTab(), RentTab(), UserTab()],
                ),
              ),
            ],
          ),
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
            ],
          ),
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
            iconSize: 36.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Theme.of(context).disabledColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 40.0,
                  ),
                  label: 'Home',
                  activeIcon: Icon(
                    Icons.home,
                    size: 40.0,
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
                    size: 40.0,
                  ),
                  label: 'User',
                  activeIcon: Icon(
                    Icons.person,
                    size: 40.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
