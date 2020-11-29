import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Booking with ChangeNotifier {
  String bookingID, trekID, trekName;
  int price;
  List<Map> people, trekGear;
  Timestamp startDate, endDate;

  Booking(
      {this.bookingID,
      this.trekName,
      this.trekID,
      this.price,
      this.people,
      this.trekGear,
      this.startDate,
      this.endDate});

  DateTime get startDateTime => startDate.toDate();

  DateTime get endDateTime => endDate.toDate();

  void updatePeople(List<Map<String, dynamic>> newPeople) {
    people = newPeople;
    notifyListeners();
  }

  void updateTrekName(String newName) {
    trekName = newName;
    notifyListeners();
  }

  void updateID(String newID) {
    bookingID = newID;
    notifyListeners();
  }

  void updateStartDate(DateTime newStartDate) {
    startDate = Timestamp.fromDate(newStartDate);
    notifyListeners();
  }

  void updateEndDate(DateTime newEndDate) {
    endDate = Timestamp.fromDate(newEndDate);
    notifyListeners();
  }

  void updateTrekGear(List<Map<String, dynamic>> newTrekGear) {
    trekGear = newTrekGear;
    notifyListeners();
  }

  void updatePrice(int newPrice) {
    price = newPrice;
    notifyListeners();
  }

  Map<String, dynamic> getBookingMap() {
    Map<String, dynamic> bookingMap = {
      'bookingID': bookingID,
      'trekID': trekID,
      'price': price,
      'people': people,
      'trekGear': trekGear,
      'startDate': startDate,
      'endDate': endDate,
      'trekName': trekName
    };
    return bookingMap;
  }
}
