import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/image_swipe.dart';

import '../constants.dart';

class TrekScreen extends StatefulWidget {
  final String trekID;
  TrekScreen({this.trekID});

  @override
  _TrekScreenState createState() => _TrekScreenState();
}

class _TrekScreenState extends State<TrekScreen> {
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    bool trekSaved = user.savedTreks.contains(widget.trekID);

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
                return SingleChildScrollView(
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
                              child: Text(
                                '${trekData['city']}, ${trekData['state']}',
                                style: cardText.copyWith(fontSize: 14.0),
                              ),
                            ),
                            Text(
                              trekData['desc'],
                              style: greyText.copyWith(fontSize: 16.0),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
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
                            Text(
                              'Customer Reviews',
                              style: cardText.copyWith(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                  GestureDetector(
                    onTap: () async {
                      if (trekSaved) {
                        user.savedTreks.remove(widget.trekID);
                        setState(() {});
                        await db.updateUser(user.getUserMap());
                      } else {
                        user.savedTreks.add(widget.trekID);
                        setState(() {});
                        await db.updateUser(user.getUserMap());
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 54.0,
                      width: 54.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).dialogBackgroundColor,
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
                  ),
                  GestureDetector(
                    onTap: () {},
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
        ],
      ),
    );
  }
}
