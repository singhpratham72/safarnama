import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/screens/booking_screen.dart';
import 'package:safarnama/services/database_service.dart';

import '../constants.dart';

class BookingCard extends StatelessWidget {
  BookingCard({
    @required this.booking,
  });
  final Map booking;
  final DatabaseService db = DatabaseService();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => FutureBuilder(
          future: db.getTrekImage(booking['trekID']),
          builder: (context, AsyncSnapshot<String> url) {
            if (url.connectionState == ConnectionState.done) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                                value: user,
                                child: BookingScreen(
                                  booking: booking,
                                  url: url.data,
                                ),
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.0, top: 24.0),
                  height: 132.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.15),
                            spreadRadius: 2.0,
                            blurRadius: 10.0,
                            offset: Offset(9, 9))
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(url.data))),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Booking ID: ${booking['bookingID']}',
                                    style: greyText.copyWith(fontSize: 12.0),
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                  ),
                                  Icon(
                                    Icons.call_made_rounded,
                                    size: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                ],
                              ),
                              Text(
                                booking['trekName'],
                                style: headingText.copyWith(fontSize: 14.0),
                              ),
                              Text(
                                '₹${booking['price']}.0',
                                style: highlightText.copyWith(fontSize: 12.0),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 18.0,
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        '${dateFormat.format(booking['startDate'].toDate())}',
                                        style: headingText.copyWith(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 24.0,
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        '${booking['people'].length}',
                                        style: headingText.copyWith(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else
              return Text('Error');
          }),
    );
  }
}
