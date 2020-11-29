import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/booking_card.dart';

import '../constants.dart';

class BookingHistoryScreen extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
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
                      text: 'Booked ',
                      style: headingText.copyWith(fontSize: 32.0),
                      children: [
                        TextSpan(
                            text: 'treks',
                            style:
                                TextStyle(color: Theme.of(context).accentColor))
                      ]),
                ),
              ],
            ),
            Consumer<User>(builder: (context, user, child) {
              List bookings = user.bookings;
              if (bookings.isNotEmpty) {
                List<Widget> bookingCards = [];
                for (Map booking in bookings) {
                  bookingCards.add(ChangeNotifierProvider.value(
                      value: user, child: BookingCard(booking: booking)));
                }

                return SingleChildScrollView(
                  child: Column(
                    children: bookingCards,
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 3)),
                  child: Center(
                    child: Text(
                      'You have no bookings.',
                      style: greyText,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
