import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/booking.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

enum PaymentMethod { credit, debit }

class CheckoutBottomSheet extends StatefulWidget {
  CheckoutBottomSheet({
    @required this.trekData,
  });
  final Map<String, dynamic> trekData;

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  DatabaseService db = DatabaseService();
  int pageSelector = 0;
  List<int> ageList = [18, 18, 18];
  List<String> nameList = [];
  final TextEditingController name1 = TextEditingController();
  final TextEditingController name2 = TextEditingController();
  final TextEditingController name3 = TextEditingController();
  DateRangePickerController _pickerController;
  List<DateTime> blackOutDates = [];
  List<DateTime> specialDates = [];
  List<DateTime> trekDates = [];
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  var uuid = Uuid();
  PaymentMethod _paymentMethod = PaymentMethod.credit;
  bool _checkout = false;

  List<int> getAgeRange() {
    List<int> ageRange = [];
    for (int i = 8; i <= 65; i++) {
      ageRange.add(i);
    }
    return ageRange;
  }

  void getBlackOutDates() {
    List trekTimeStamps = widget.trekData['dates'];
    for (Timestamp dayStamp in trekTimeStamps) {
      trekDates.add(dayStamp.toDate());
    }
    print(trekDates);

    for (DateTime day = DateTime(2020, 11, 27);
        day.isBefore(DateTime(2022, 1, 1));
        day = day.add(Duration(days: 1))) {
      if (trekDates.contains(day)) {
        for (int i = 1; i < widget.trekData['duration']; i++) {
          day = day.add(Duration(days: 1));
          specialDates.add(day);
        }
        continue;
      }
      blackOutDates.add(day);
    }
  }

  @override
  void initState() {
    getBlackOutDates();
    _pickerController = DateRangePickerController();
    DateTime initDate = trekDates[0];
    DateTime endDate =
        initDate.add(Duration(days: widget.trekData['duration'] - 1));
    print('Start: $initDate  \n End: $endDate');
    _pickerController.displayDate = initDate;
    _pickerController.selectedRange = PickerDateRange(initDate, endDate);
    _pickerController.view = DateRangePickerView.month;
    _pickerController.addPropertyChangedListener((String property) {
      if (property == 'selectedRange') {
        initDate = _pickerController.selectedRange.startDate;
        if (trekDates.contains(initDate)) {
          print('true');
          endDate =
              initDate.add(Duration(days: widget.trekData['duration'] - 1));
          _pickerController.selectedRange = PickerDateRange(initDate, endDate);
          setState(() {});
        } else if (initDate.isAfter(trekDates[0])) {
          print('false');
          while (!trekDates.contains(initDate)) {
            initDate = initDate.subtract(Duration(days: 1));
          }
          endDate =
              initDate.add(Duration(days: widget.trekData['duration'] - 1));
          _pickerController.selectedRange = PickerDateRange(initDate, endDate);
          setState(() {});
        } else {
          print('Property Change: $property and this: $initDate');
        }
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Consumer<Booking>(builder: (context, booking, child) {
      if (pageSelector == 0)
      // SelectDate
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    iconSize: 18.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Pick ',
                      style: headingText.copyWith(
                          color: Theme.of(context).accentColor, fontSize: 24.0),
                      children: [
                        TextSpan(
                            text: 'dates',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: 12.0,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  border: Border.all(color: Theme.of(context).accentColor)),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                child: SfDateRangePicker(
                  headerHeight: 50.0,
                  headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                      backgroundColor: Theme.of(context).accentColor),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      specialDatesTextStyle: TextStyle(color: Colors.black87),
                      blackoutDateTextStyle:
                          TextStyle(color: Theme.of(context).disabledColor)),
                  onSelectionChanged: (dateChanged) {
                    print(dateChanged.value);
                    _pickerController.selectedRange = dateChanged.value;
                    print(_pickerController.selectedRange.endDate);
                  },
                  view: _pickerController.view,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      specialDates: specialDates,
                      blackoutDates: blackOutDates,
                      showTrailingAndLeadingDates: false),
                  rangeSelectionColor:
                      Theme.of(context).accentColor.withOpacity(0.2),
                  endRangeSelectionColor: Theme.of(context).accentColor,
                  controller: _pickerController,
                  initialDisplayDate: _pickerController.displayDate,
                  initialSelectedRange: _pickerController.selectedRange,
                  selectionMode: DateRangePickerSelectionMode.range,
                  enablePastDates: false,
                  showNavigationArrow: true,
                  minDate: DateTime.now(),
                  maxDate: DateTime(2021, 12, 31),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(10.0),
                  //     bottomRight: Radius.circular(10.0)),
                  border: Border(
                bottom: BorderSide(color: Theme.of(context).accentColor),
                left: BorderSide(color: Theme.of(context).accentColor),
                right: BorderSide(color: Theme.of(context).accentColor),
                top: BorderSide(color: Colors.white),
              )),
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        '${dateFormat.format(_pickerController.selectedRange.startDate)}',
                    style: headingText.copyWith(fontSize: 20.0),
                    children: [
                      TextSpan(
                          text: ' to ',
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      TextSpan(
                          text:
                              '${dateFormat.format(_pickerController.selectedRange.endDate)}',
                          style: TextStyle(color: Colors.black))
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    booking.updateStartDate(
                        _pickerController.selectedRange.startDate);
                    booking
                        .updateEndDate(_pickerController.selectedRange.endDate);
                    setState(() {
                      pageSelector = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).accentColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "Proceed",
                      style: buttonText.copyWith(fontSize: 20.0),
                    ),
                  )),
            )
          ],
        );
      } else if (pageSelector == 1)
      // Trekker Details
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    iconSize: 18.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18.0,
                    ),
                    onPressed: () {
                      setState(() {
                        pageSelector = 0;
                      });
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Fellow ',
                      style: headingText.copyWith(
                          color: Theme.of(context).accentColor, fontSize: 24.0),
                      children: [
                        TextSpan(
                            text: 'trekkers',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextField(
                        controller: name1,
                        cursorColor: Theme.of(context).accentColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Trekker 1",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (name1.text.length == 1)
                            setState(() {});
                          else if (name1.text.isEmpty) setState(() {});
                        },
                      )),
                  DropdownButton(
                      style: headingText.copyWith(
                          color: name1.text.isNotEmpty
                              ? Theme.of(context).accentColor
                              : Theme.of(context).disabledColor),
                      value: ageList[0],
                      onChanged: (selectedAge) {
                        setState(() {
                          ageList[0] = selectedAge;
                        });
                      },
                      items:
                          getAgeRange().map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList())
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextField(
                        enabled: name1.text.isNotEmpty,
                        controller: name2,
                        cursorColor: Theme.of(context).accentColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Trekker 2",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (name2.text.length == 1)
                            setState(() {});
                          else if (name2.text.isEmpty) setState(() {});
                        },
                      )),
                  DropdownButton(
                      style: headingText.copyWith(
                          color: name2.text.isNotEmpty
                              ? Theme.of(context).accentColor
                              : Theme.of(context).disabledColor),
                      value: ageList[1],
                      onChanged: (selectedAge) {
                        setState(() {
                          ageList[1] = selectedAge;
                        });
                      },
                      items:
                          getAgeRange().map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList())
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextField(
                        controller: name3,
                        enabled: name2.text.isNotEmpty,
                        cursorColor: Theme.of(context).accentColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Trekker 3",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (name3.text.length == 1)
                            setState(() {});
                          else if (name3.text.isEmpty) setState(() {});
                        },
                      )),
                  DropdownButton(
                      style: headingText.copyWith(
                          color: name3.text.isNotEmpty
                              ? Theme.of(context).accentColor
                              : Theme.of(context).disabledColor),
                      value: ageList[2],
                      onChanged: (selectedAge) {
                        setState(() {
                          ageList[2] = selectedAge;
                        });
                      },
                      items:
                          getAgeRange().map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList())
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    List<Map<String, dynamic>> people = [];
                    if (name1.text.isNotEmpty) {
                      if (name2.text.isNotEmpty) {
                        if (name3.text.isNotEmpty) {
                          people = [
                            {'name': name1.text, 'age': ageList[0]},
                            {'name': name2.text, 'age': ageList[1]},
                            {'name': name3.text, 'age': ageList[2]}
                          ];
                        } else {
                          people = [
                            {'name': name1.text, 'age': ageList[0]},
                            {'name': name2.text, 'age': ageList[1]},
                          ];
                        }
                      } else {
                        people = [
                          {'name': name1.text, 'age': ageList[0]},
                        ];
                      }
                      booking.updatePeople(people);
                      booking.updatePrice(
                          (widget.trekData['price']) * (booking.people.length));
                      print(booking.people);
                      setState(() {
                        pageSelector = 2;
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: name1.text.isNotEmpty
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "Proceed",
                      style: buttonText.copyWith(fontSize: 20.0),
                    ),
                  )),
            ),
          ],
        );
      } else
      // Checkout
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    iconSize: 18.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18.0,
                    ),
                    onPressed: () {
                      setState(() {
                        pageSelector = 1;
                      });
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Confirm ',
                      style: headingText.copyWith(
                          color: Theme.of(context).accentColor, fontSize: 24.0),
                      children: [
                        TextSpan(
                            text: 'and get going',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trek Name',
                            style: greyText.copyWith(fontSize: 18.0),
                          ),
                          Text(
                            '${widget.trekData['name']}',
                            style: headingText.copyWith(
                                fontSize: 22.0, color: Colors.black87),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Text(
                            'Price (per person)',
                            style: greyText.copyWith(fontSize: 18.0),
                          ),
                          Text(
                            '₹${widget.trekData['price']}/-',
                            style: headingText.copyWith(
                                fontSize: 22.0, color: Colors.black87),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: greyText.copyWith(fontSize: 18.0),
                          ),
                          Text(
                            '${widget.trekData['city']}',
                            style: headingText.copyWith(
                                fontSize: 22.0, color: Colors.black87),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Text(
                            'Trekkers',
                            style: greyText.copyWith(fontSize: 18.0),
                          ),
                          Text(
                            '${booking.people.length}',
                            style: headingText.copyWith(
                                fontSize: 22.0, color: Colors.black87),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 16.0),
              child: RichText(
                text: TextSpan(
                    text: 'Total: ',
                    style: headingText.copyWith(
                        color: Colors.black, fontSize: 24.0),
                    children: [
                      TextSpan(
                          text: '₹${booking.price}.0',
                          style:
                              TextStyle(color: Theme.of(context).accentColor))
                    ]),
              ),
            ),
            Column(
              children: [
                RadioListTile<PaymentMethod>(
                  dense: true,
                  title: Text(
                    'Pay with Credit Card',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  value: PaymentMethod.credit,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                RadioListTile<PaymentMethod>(
                  dense: true,
                  title: Text(
                    'Pay with Debit Card',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  value: PaymentMethod.debit,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                )
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _checkout = true;
                    });
                    String bookingUID =
                        'SF' + uuid.v1().toUpperCase().substring(25, 32);
                    booking.updateID(bookingUID);
                    Map<String, dynamic> bookingMap = booking.getBookingMap();
                    user.bookings.add(bookingMap);
                    await db.updateUser(user.getUserMap());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your trek has been successfully booked.'),
                    ));
                    setState(() {
                      _checkout = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: name1.text.isNotEmpty
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: _checkout
                        ? Container(
                            height: 26.0,
                            width: 26.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            "Checkout",
                            style: buttonText.copyWith(fontSize: 20.0),
                          ),
                  )),
            ),
          ],
        );
      }
    });
  }
}
