import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/gear_size.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

enum PaymentMethod { credit, debit }

class GearScreen extends StatefulWidget {
  final String gearID;
  GearScreen({this.gearID});

  @override
  _GearScreenState createState() => _GearScreenState();
}

class _GearScreenState extends State<GearScreen> {
  final DatabaseService db = DatabaseService();
  String _selectedGearSize = "";
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder(
            future: db.gearsRef.doc(widget.gearID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> gearData = snapshot.data.data();
                List gearSizes = gearData['size'];
                _selectedGearSize = gearSizes[0];
                return Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          padding: EdgeInsets.only(
                              top: 108.0, left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.222),
                                  spreadRadius: 5.0,
                                  blurRadius: 16.0,
                                  offset: Offset(0, 9))
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(gearData['image'])),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 20.0, right: 20.0, bottom: 96.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gearData['name'],
                                style: cardText.copyWith(fontSize: 24.0),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  gearData['desc'],
                                  style: greyText.copyWith(fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Gear Rent',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '₹${gearData['price']}',
                                          style:
                                              cardText.copyWith(fontSize: 18.0),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 54.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          gearData['type']
                                              .toString()
                                              .toUpperCase(),
                                          style:
                                              cardText.copyWith(fontSize: 18.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Size',
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              GearSize(
                                gearSizes: gearSizes,
                                onSelected: (size) {
                                  _selectedGearSize = size;
                                },
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
                          print(_selectedGearSize);
                          if (user.bookings.isNotEmpty) {
                            List<Map> showBookings = [];
                            for (Map booking in user.bookings) {
                              String bookingName =
                                  await db.getTrekName(booking['trekID']);
                              Timestamp date = booking['startDate'];
                              String bookingDate =
                                  dateFormat.format(date.toDate());
                              Map<String, String> bookingData = {
                                'name': bookingName,
                                'date': bookingDate,
                                'id': booking['bookingID']
                              };
                              showBookings.add(bookingData);
                            }

                            String _selectedBooking = showBookings[0]['id'];
                            PaymentMethod _paymentMethod = PaymentMethod.credit;
                            bool _checkout = false;

                            showModalBottomSheet(
                                isDismissible: false,
                                backgroundColor: Color(0xff757575),
                                context: context,
                                isScrollControlled: true,
                                builder:
                                    (context) => StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setModalState) {
                                          void changeSelectedBooking(
                                              String value) {
                                            setModalState(() {
                                              _selectedBooking = value;
                                            });
                                          }

                                          List<Widget> radioList = [];
                                          for (Map booking in showBookings) {
                                            radioList.add(
                                              RadioListTile(
                                                contentPadding:
                                                    EdgeInsets.all(0.0),
                                                dense: true,
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      booking['name'],
                                                      style: TextStyle(
                                                          fontSize: 18.0),
                                                    ),
                                                    Text(
                                                      booking['date'],
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                    ),
                                                  ],
                                                ),
                                                value: booking['id'],
                                                groupValue: _selectedBooking,
                                                onChanged: (value) {
                                                  changeSelectedBooking(value);
                                                },
                                              ),
                                            );
                                          }
                                          return MultiProvider(
                                            providers: [
                                              ChangeNotifierProvider.value(
                                                  value: user)
                                            ],
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.0,
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  top: 20.0,
                                                  bottom: 30.0,
                                                  right: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(32.0),
                                                  topLeft:
                                                      Radius.circular(32.0),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 24.0,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: IconButton(
                                                            iconSize: 18.0,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            icon: Icon(
                                                              Icons
                                                                  .arrow_back_ios_sharp,
                                                              size: 18.0,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                              text: 'Select ',
                                                              style: headingText
                                                                  .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      fontSize: 24.0),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        'booking and pay',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                                'Bookings',
                                                                style:
                                                                    greyText),
                                                          ),
                                                          Column(
                                                            children: radioList,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    top: 10.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black87),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                              ),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    text:
                                                                        'Total: ',
                                                                    style: headingText.copyWith(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            22.0),
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              '₹${gearData['price']}.0',
                                                                          style:
                                                                              TextStyle(color: Theme.of(context).accentColor))
                                                                    ]),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                                'Payment Methods',
                                                                style:
                                                                    greyText),
                                                          ),
                                                          RadioListTile<
                                                              PaymentMethod>(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            dense: true,
                                                            title: Text(
                                                              'Pay on Arrival',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                            value: PaymentMethod
                                                                .credit,
                                                            groupValue:
                                                                _paymentMethod,
                                                            onChanged:
                                                                (PaymentMethod
                                                                    value) {
                                                              setModalState(() {
                                                                _paymentMethod =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      print(
                                                                          _selectedBooking);
                                                                      setModalState(
                                                                          () {
                                                                        _checkout =
                                                                            true;
                                                                      });

                                                                      Map<String,
                                                                              dynamic>
                                                                          rentedGearMap =
                                                                          {
                                                                        'name':
                                                                            gearData['name'],
                                                                        'gearID':
                                                                            widget.gearID,
                                                                        'size':
                                                                            _selectedGearSize
                                                                      };
                                                                      int bookingIndex =
                                                                          0;
                                                                      for (Map booking
                                                                          in user
                                                                              .bookings) {
                                                                        if (booking['bookingID'] ==
                                                                            _selectedBooking) {
                                                                          if (user.bookings[bookingIndex]['trekGear'] ==
                                                                              null) {
                                                                            user.bookings[bookingIndex]['trekGear'] =
                                                                                [
                                                                              rentedGearMap
                                                                            ];
                                                                          } else {
                                                                            user.bookings[bookingIndex]['trekGear'].add(rentedGearMap);
                                                                          }
                                                                          break;
                                                                        }
                                                                        bookingIndex++;
                                                                      }
                                                                      await db.updateUser(
                                                                          user.getUserMap());
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text('Your gear has been successfully rented.'),
                                                                      ));
                                                                      setState(
                                                                          () {
                                                                        _checkout =
                                                                            false;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              16.0),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          54.0,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.5,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12.0),
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              12.0),
                                                                      child: _checkout
                                                                          ? Container(
                                                                              height: 26.0,
                                                                              width: 26.0,
                                                                              child: CircularProgressIndicator(strokeWidth: 3.0, backgroundColor: Colors.white, color: Theme.of(context).accentColor),
                                                                            )
                                                                          : Text(
                                                                              "Checkout",
                                                                              style: buttonText.copyWith(fontSize: 20.0),
                                                                            ),
                                                                    )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'You have no bookings to rent  gear for.'),
                            ));
                          }
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
                            "Rent Now",
                            style: buttonText.copyWith(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]);
              }
              //Loading
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor),
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
