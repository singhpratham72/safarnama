import 'package:flutter/cupertino.dart';
import 'package:safarnama/services/database_service.dart';

class User with ChangeNotifier {
  DatabaseService db = DatabaseService();

  String name, phone, email;
  List savedTreks, bookings;
  User({this.name, this.phone, this.email, this.bookings, this.savedTreks});

  factory User.fromMap(Map data) {
    return User(
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        bookings: data['bookings'],
        savedTreks: data['savedTreks']);
  }

  void cancelBooking(Map booking) {
    bookings.remove(booking);
    notifyListeners();
  }

  Map<String, dynamic> getUserMap() {
    Map<String, dynamic> userData = {
      'name': name,
      'phone': phone,
      'email': email,
      'bookings': bookings,
      'savedTreks': savedTreks,
    };
    return userData;
  }
}
