import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/gear_card.dart';

import '../constants.dart';

class RentTab extends StatefulWidget {
  @override
  _RentTabState createState() => _RentTabState();
}

class _RentTabState extends State<RentTab> {
  final db = DatabaseService();
  bool search = false;

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
      await db.searchGearByName(value).then((QuerySnapshot gears) {
        for (int i = 0; i < gears.size; i++) {
          queryResultSet.add(gears.docs[i]);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((gear) {
        if (gear.data()['name'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (gear.data()['name'].toLowerCase().indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(gear);
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
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
      ),
      child: Column(
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
                        hintText: 'Search for trekking gear',
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
              child: GridView.count(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 32.0,
                crossAxisCount: 2,
                padding: EdgeInsets.only(
                    bottom: 24.0, top: 12.0, right: 10.0, left: 10.0),
                shrinkWrap: true,
                children: tempSearchStore.map((gearDoc) {
                  Map<String, dynamic> gearData = gearDoc.data();
                  return GearCard(
                    id: gearDoc.id,
                    name: gearData['name'],
                    desc: gearData['desc'],
                    type: gearData['type'],
                    price: gearData['price'],
                    url: gearData['image'],
                  );
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Backpacks',
                            style: headingText.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.gearsRef
                                .where('type', isEqualTo: 'backpack')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data.docs.map((gearDoc) {
                                      Map<String, dynamic> gearData =
                                          gearDoc.data();
                                      return GearCard(
                                        id: gearDoc.id,
                                        name: gearData['name'],
                                        desc: gearData['desc'],
                                        type: gearData['type'],
                                        price: gearData['price'],
                                        url: gearData['image'],
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jackets',
                            style: headingText.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.gearsRef
                                .where('type', isEqualTo: 'jacket')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data.docs.map((gearDoc) {
                                      Map<String, dynamic> gearData =
                                          gearDoc.data();
                                      return GearCard(
                                        id: gearDoc.id,
                                        name: gearData['name'],
                                        desc: gearData['desc'],
                                        type: gearData['type'],
                                        price: gearData['price'],
                                        url: gearData['image'],
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trekking Poles',
                            style: headingText.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.gearsRef
                                .where('type', isEqualTo: 'pole')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data.docs.map((gearDoc) {
                                      Map<String, dynamic> gearData =
                                          gearDoc.data();
                                      return GearCard(
                                        id: gearDoc.id,
                                        name: gearData['name'],
                                        desc: gearData['desc'],
                                        type: gearData['type'],
                                        price: gearData['price'],
                                        url: gearData['image'],
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trekking Shoes',
                            style: headingText.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.gearsRef
                                .where('type', isEqualTo: 'shoes')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data.docs.map((gearDoc) {
                                      Map<String, dynamic> gearData =
                                          gearDoc.data();
                                      return GearCard(
                                        id: gearDoc.id,
                                        name: gearData['name'],
                                        desc: gearData['desc'],
                                        type: gearData['type'],
                                        price: gearData['price'],
                                        url: gearData['image'],
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ponchos',
                            style: headingText.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.gearsRef
                                .where('type', isEqualTo: 'poncho')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data.docs.map((gearDoc) {
                                      Map<String, dynamic> gearData =
                                          gearDoc.data();
                                      return GearCard(
                                        id: gearDoc.id,
                                        name: gearData['name'],
                                        desc: gearData['desc'],
                                        type: gearData['type'],
                                        price: gearData['price'],
                                        url: gearData['image'],
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
