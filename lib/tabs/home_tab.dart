import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/tabs/user_tab.dart';
import 'package:safarnama/widgets/trek_cards.dart';

import '../constants.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final db = DatabaseService();

    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 64),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Treks ',
                  style: headingText.copyWith(
                      color: Theme.of(context).accentColor, fontSize: 20.0),
                  children: [
                    TextSpan(
                        text: 'near you', style: TextStyle(color: Colors.black))
                  ]),
            ),
            FutureBuilder<QuerySnapshot>(
              future: db.treksRef.get(),
              builder: (context, snapshot) {
                // Snap error
                if (snapshot.hasError) return Text('ErrorL ${snapshot.error}');

                //Snap connected
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: 220.0,
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs.map((trekDoc) {
                        Map<String, dynamic> trekData = trekDoc.data();
                        return TrekCardA(
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
                    future: db.treksRef.get(),
                    builder: (context, snapshot) {
                      // Snap error
                      if (snapshot.hasError)
                        return Text('ErrorL ${snapshot.error}');

                      //Snap connected
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((trekDoc) {
                            Map<String, dynamic> trekData = trekDoc.data();
                            return TrekCardB(
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
    );
  }
}
