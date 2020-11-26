import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/authentication_service.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/trek_cards.dart';

import '../constants.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool search = false;
  final db = DatabaseService();

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        search = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    } else
      setState(() {
        search = true;
      });

    // var capitalizedValue =
    //     value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      await db.searchTrekByName(value).then((QuerySnapshot treks) {
        for (int i = 0; i < treks.size; i++) {
          queryResultSet.add(treks.docs[i]);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((trek) {
        if (trek.data()['name'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (trek.data()['name'].toLowerCase().indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(trek);
            });
          }
        }
      });
    }

    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 20.0),
            padding: EdgeInsets.only(left: 20.0),
            height: 50.0,
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.1),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: Offset(7, 7))
                ]),
            child: Row(
              children: [
                Icon(Icons.search, color: Theme.of(context).disabledColor),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    onChanged: (text) {
                      initiateSearch(text);
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for treks',
                        hintStyle:
                            TextStyle(color: Theme.of(context).disabledColor),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 0.0,
                        )),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: search && queryResultSet.isNotEmpty,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 0.0, top: 16.0, right: 20.0),
                shrinkWrap: true,
                children: tempSearchStore.map((trekDoc) {
                  Map<String, dynamic> trekData = trekDoc.data();
                  return TrekCardB(
                      id: trekDoc.id,
                      name: trekData['name'],
                      city: trekData['city'],
                      state: trekData['state'],
                      price: trekData['price'],
                      url: trekData['images'][0],
                      difficulty: trekData['difficulty'],
                      duration: trekData['duration']);
                }).toList(),
              ),
            ),
          ),
          Visibility(
            visible: search && queryResultSet.isEmpty,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              child: Center(
                  child: Text(
                'No results found.',
                style: greyText,
              )),
            ),
          ),
          Visibility(
            visible: !search,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Treks ',
                          style: headingText.copyWith(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0),
                          children: [
                            TextSpan(
                                text: 'near you',
                                style: TextStyle(color: Colors.black))
                          ]),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: db.treksRef.limit(5).get(),
                      builder: (context, snapshot) {
                        // Snap error
                        if (snapshot.hasError)
                          return Text('ErrorL ${snapshot.error}');

                        //Snap connected
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            height: 238.0,
                            child: ListView(
                              padding: EdgeInsets.only(bottom: 44.0, top: 12.0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs.map((trekDoc) {
                                Map<String, dynamic> trekData = trekDoc.data();
                                return TrekCardA(
                                  id: trekDoc.id,
                                  name: trekData['name'],
                                  city: trekData['city'],
                                  state: trekData['state'],
                                  price: trekData['price'],
                                  url: trekData['images'][0],
                                );
                              }).toList(),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Upcoming ',
                                    style: headingText.copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.0),
                                    children: [
                                      TextSpan(
                                          text: 'treks',
                                          style: TextStyle(color: Colors.black))
                                    ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //View all treks
                                  context
                                      .read<AuthenticationService>()
                                      .signOut();
                                },
                                child: Text(
                                  'View all',
                                  style: highlightText.copyWith(fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.treksRef.limit(3).get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView(
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(bottom: 24.0, top: 12.0),
                                  shrinkWrap: true,
                                  children: snapshot.data.docs.map((trekDoc) {
                                    Map<String, dynamic> trekData =
                                        trekDoc.data();
                                    return TrekCardB(
                                        id: trekDoc.id,
                                        name: trekData['name'],
                                        city: trekData['city'],
                                        state: trekData['state'],
                                        price: trekData['price'],
                                        url: trekData['images'][0],
                                        difficulty: trekData['difficulty'],
                                        duration: trekData['duration']);
                                  }).toList(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Beginner ',
                                  style: headingText.copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20.0),
                                  children: [
                                    TextSpan(
                                        text: 'treks',
                                        style: TextStyle(color: Colors.black))
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  //View all treks
                                },
                                child: Text(
                                  'View all',
                                  style: highlightText.copyWith(fontSize: 14.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: db.treksRef
                              .where('difficulty', isEqualTo: 'Easy')
                              .limit(3)
                              .get(),
                          builder: (context, snapshot) {
                            // Snap error
                            if (snapshot.hasError)
                              return Text('ErrorL ${snapshot.error}');

                            //Snap connected
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                height: 238.0,
                                child: ListView(
                                  padding:
                                      EdgeInsets.only(bottom: 44.0, top: 12.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: snapshot.data.docs.map((trekDoc) {
                                    Map<String, dynamic> trekData =
                                        trekDoc.data();
                                    return TrekCardA(
                                      id: trekDoc.id,
                                      name: trekData['name'],
                                      city: trekData['city'],
                                      state: trekData['state'],
                                      price: trekData['price'],
                                      url: trekData['images'][0],
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Weekend ',
                                    style: headingText.copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.0),
                                    children: [
                                      TextSpan(
                                          text: 'treks',
                                          style: TextStyle(color: Colors.black))
                                    ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //View all treks
                                },
                                child: Text(
                                  'View all',
                                  style: highlightText.copyWith(fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.treksRef
                                .where('duration', isLessThan: 4)
                                .limit(3)
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView(
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(bottom: 24.0, top: 12.0),
                                  shrinkWrap: true,
                                  children: snapshot.data.docs.map((trekDoc) {
                                    Map<String, dynamic> trekData =
                                        trekDoc.data();
                                    return TrekCardB(
                                        id: trekDoc.id,
                                        name: trekData['name'],
                                        city: trekData['city'],
                                        state: trekData['state'],
                                        price: trekData['price'],
                                        url: trekData['images'][0],
                                        difficulty: trekData['difficulty'],
                                        duration: trekData['duration']);
                                  }).toList(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
