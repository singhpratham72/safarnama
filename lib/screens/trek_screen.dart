import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/booking.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/screens/checkout_screen.dart';
import 'package:safarnama/screens/map_screen.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/add_review.dart';
import 'package:safarnama/widgets/image_swipe.dart';
import 'package:safarnama/widgets/review_card.dart';

import '../constants.dart';

class TrekScreen extends StatefulWidget {
  final String trekID;
  TrekScreen({this.trekID});

  @override
  _TrekScreenState createState() => _TrekScreenState();
}

class _TrekScreenState extends State<TrekScreen> {
  final DatabaseService db = DatabaseService();

  void reviewAdder() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    bool trekDone() {
      if (user.bookings.isEmpty) {
        return false;
      } else {
        for (Map booking in user.bookings) {
          DateTime endDate = booking['endDate'].toDate();
          if (booking['trekID'] == widget.trekID &&
              endDate.isBefore(DateTime.now())) {
            return true;
          }
        }
        return false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder(
            future: db.treksRef.doc(widget.trekID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> trekData = snapshot.data.data();
                List imageList = trekData['images'];
                return Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ImageSwipe(
                          imageList: imageList,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 20.0, right: 20.0, bottom: 96.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trekData['name'],
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print('User: ${user.position}');
                                    print(trekData['position']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GoogleMapScreen(
                                                  trekData: trekData,
                                                  campPosition:
                                                      trekData['position']
                                                          ['geopoint'],
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${trekData['city']}, ${trekData['state']}',
                                            style: cardText.copyWith(
                                                fontSize: 14.0),
                                          ),
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 18.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Show on map',
                                        style: highlightText,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                trekData['desc'],
                                style: greyText.copyWith(fontSize: 16.0),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Trek Fee',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '₹${trekData['price']}',
                                          style:
                                              cardText.copyWith(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Reviews',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '4.0 \u2605\u2605\u2605\u2605',
                                          style: highlightText.copyWith(
                                              fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pickup Point',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          trekData['pickup'],
                                          style:
                                              cardText.copyWith(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Highlights',
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.signal_cellular_alt,
                                          color: Theme.of(context).accentColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Difficulty',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              trekData['difficulty'],
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Theme.of(context).accentColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Duration',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${trekData['duration']} Days',
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.height,
                                          color: Theme.of(context).accentColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Max. Altitude',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${trekData['altitude']} ft',
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Customer Reviews',
                                    style: cardText.copyWith(fontSize: 20.0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      bool hasDoneTrek = trekDone();
                                      if (hasDoneTrek) {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => AddReview(
                                                  setState: reviewAdder,
                                                  userName: user.name,
                                                  trekID: widget.trekID,
                                                ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'You can review this trek only if you have been on it with us.'),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 6.0),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .accentColor)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Post',
                                            style: buttonText.copyWith(
                                                fontSize: 14.0),
                                          ),
                                          Icon(
                                            Icons.add,
                                            size: 18.0,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              FutureBuilder(
                                future: db.treksRef
                                    .doc(widget.trekID)
                                    .collection('Reviews')
                                    .get(),
                                builder: (context, AsyncSnapshot reviewSnap) {
                                  if (reviewSnap.hasError)
                                    return Container(
                                      child: Center(
                                        child:
                                            Text('Error: ${reviewSnap.error}'),
                                      ),
                                    );
                                  if (reviewSnap.connectionState ==
                                      ConnectionState.done) {
                                    if (!reviewSnap.data.docs.isEmpty)
                                      return ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 12.0,
                                        ),
                                        children: reviewSnap.data.docs
                                            .map<Widget>((reviewDoc) {
                                          Map<String, dynamic> reviewDocData =
                                              reviewDoc.data();
                                          return ReviewCard(
                                            name: reviewDocData['userName'],
                                            review: reviewDocData['review'],
                                            rating: reviewDocData['rating'],
                                          );
                                        }).toList(),
                                      );
                                    else
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                            child: (Text('No reviews yet.'))),
                                      );
                                  }
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      height: 96.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFEFEEEE).withOpacity(0.82),
                              spreadRadius: 5.0,
                              blurRadius: 7,
                              offset: Offset(0, 0))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatefulBuilder(
                              builder: (context, StateSetter _setState) {
                            bool trekSaved =
                                user.savedTreks.contains(widget.trekID);
                            return GestureDetector(
                              onTap: () async {
                                if (trekSaved) {
                                  user.savedTreks.remove(widget.trekID);
                                  _setState(() {});
                                  await db.updateUser(user.getUserMap());
                                } else {
                                  user.savedTreks.add(widget.trekID);
                                  _setState(() {});
                                  await db.updateUser(user.getUserMap());
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 54.0,
                                width: 54.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color:
                                      Theme.of(context).dialogBackgroundColor,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Icon(
                                  trekSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Theme.of(context).accentColor,
                                  size: 32.0,
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Color(0xff757575),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => Booking(
                                          trekID: widget.trekID,
                                          trekName: trekData['name']),
                                    ),
                                    ChangeNotifierProvider.value(value: user)
                                  ],
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          top: 20.0,
                                          bottom: 30.0,
                                          right: 20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(32.0),
                                          topLeft: Radius.circular(32.0),
                                        ),
                                      ),
                                      child: CheckoutBottomSheet(
                                          trekData: trekData),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 54.0,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Theme.of(context).accentColor,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_sharp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "Book Now",
                                    style: buttonText.copyWith(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
              }
              //Loading
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 56.0, left: 20.0),
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.15),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: Offset(5, 5))
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20.0,
                color: Color(0xFF000000).withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
