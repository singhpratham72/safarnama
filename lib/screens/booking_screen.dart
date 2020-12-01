import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class BookingScreen extends StatelessWidget {
  final Map booking;
  final String url;
  BookingScreen({this.booking, this.url});
  final DatabaseService db = DatabaseService();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    bool exists = true;

    Future<void> _cancelBookingDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Trek Cancellation',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You are about to cancel your trek booking for ${booking['trekName']}.'),
                  Text('Are you sure you want to continue?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Exit',
                  style: greyText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Confirm',
                  style:
                      greyText.copyWith(color: Theme.of(context).accentColor),
                ),
                onPressed: () async {
                  user.cancelBooking(booking);
                  exists = false;
                  await db.updateUser(user.getUserMap());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Your trek booking has been cancelled.'),
                  ));
                },
              ),
            ],
          );
        },
      );
    }

    String startDate = dateFormat.format(booking['startDate'].toDate());
    String endDate = dateFormat.format(booking['endDate'].toDate());
    List<Widget> c1 = [
      Text(
        'S.No.',
        style: greyText,
      )
    ];
    List<Widget> c2 = [
      Text(
        'Name',
        style: greyText,
      ),
    ];
    List<Widget> c3 = [
      Text(
        'Age',
        style: greyText,
      )
    ];
    int i = 1;
    for (Map person in booking['people']) {
      c1.add(Text(
        '$i.',
        style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
      ));
      i++;
      c2.add(Text(
        '${person['name']}',
        style: TextStyle(fontSize: 20.0),
      ));
      c3.add(Text(
        '${person['age']}',
        style: TextStyle(fontSize: 20.0),
      ));
    }
    List<Widget> c4 = [
      Text(
        'S.No.',
        style: greyText,
      )
    ];
    List<Widget> c5 = [
      Text(
        'Gear',
        style: greyText,
      ),
    ];
    List<Widget> c6 = [
      Text(
        'Size',
        style: greyText,
      )
    ];

    i = 1;

    if (booking['trekGear'] != null) {
      for (Map gear in booking['trekGear']) {
        c4.add(Text(
          '$i.',
          style:
              TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
        ));
        i++;
        c5.add(Text(
          '${gear['name']}',
          style: TextStyle(fontSize: 20.0),
        ));
        c6.add(Text(
          '${gear['size']}',
          style: TextStyle(fontSize: 20.0),
        ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Stack(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    padding:
                        EdgeInsets.only(top: 108.0, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitHeight, image: NetworkImage(url)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.222),
                            spreadRadius: 5.0,
                            blurRadius: 16.0,
                            offset: Offset(0, 9))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0, bottom: 108.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['trekName'],
                          style: cardText.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text('$startDate to $endDate',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).accentColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking ID',
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              Text(
                                '${booking['bookingID']}',
                                style: greyText.copyWith(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trekkers ',
                                    style: cardText.copyWith(fontSize: 20.0),
                                  ),
                                  Icon(
                                    Icons.people,
                                    color: Theme.of(context).accentColor,
                                    size: 28.0,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: c1,
                                  ),
                                  SizedBox(
                                    width: 18.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: c2,
                                  ),
                                  SizedBox(
                                    width: 36.0,
                                  ),
                                  Column(
                                    children: c3,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gear Rentals ',
                                    style: cardText.copyWith(fontSize: 20.0),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.hiking,
                                    color: Theme.of(context).accentColor,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                              booking['trekGear'] != null
                                  ? Row(
                                      children: [
                                        Column(
                                          children: c4,
                                        ),
                                        SizedBox(
                                          width: 18.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: c5,
                                        ),
                                        SizedBox(
                                          width: 36.0,
                                        ),
                                        Column(
                                          children: c6,
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        'No gear rentals.',
                                        style: greyText,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: cardText.copyWith(fontSize: 20.0),
                            ),
                            Text(
                              '₹${booking['price']}.0',
                              style: cardText.copyWith(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
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
                  left: 20.0,
                  right: 20.0,
                  bottom: 32.0,
                ),
                height: 96.0,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () async {
                    await _cancelBookingDialog(context);
                    if (!exists) Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).accentColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "Cancel",
                      style: buttonText.copyWith(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ]),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 56.0, left: 20.0),
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
