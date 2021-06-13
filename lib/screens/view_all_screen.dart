import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/trek_cards.dart';

import '../constants.dart';

class ViewAllScreen extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final String view;

  ViewAllScreen({@required this.view});

  @override
  Widget build(BuildContext context) {
    String title = 'All';
    Future getTreks = db.treksRef.get();
    if (view == 'weekend') {
      title = 'Weekend';
      getTreks = db.treksRef.where('duration', isLessThan: 5).get();
    } else if (view == 'beginner') {
      title = 'Beginner';
      getTreks = db.treksRef.where('difficulty', isEqualTo: 'Easy').get();
    } else if (view == 'upcoming') {
      Timestamp queryDate =
          Timestamp.fromDate(DateTime.now().add(Duration(days: 90)));
      title = 'Upcoming';
      getTreks = db.treksRef.where('startDate', isLessThan: queryDate).get();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 56.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0),
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.15),
                            spreadRadius: 1.0,
                            blurRadius: 8.0,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: title,
                      style: headingText.copyWith(fontSize: 32.0),
                      children: [
                        TextSpan(
                            text: ' treks',
                            style:
                                TextStyle(color: Theme.of(context).accentColor))
                      ]),
                ),
              ],
            ),
            Consumer<User>(builder: (context, user, child) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: FutureBuilder<QuerySnapshot>(
                    future: getTreks,
                    builder: (context, snapshot) {
                      // Snap error
                      if (snapshot.hasError)
                        return Text('ErrorL ${snapshot.error}');

                      //Snap connected
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView(
                          padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((trekDoc) {
                            Map<String, dynamic> trekData = trekDoc.data();
                            return TrekCardD(
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
                          child: CircularProgressIndicator(
                            color: Theme.of(context).accentColor
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
