import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  String name, phone, email;
  List rentedGear, savedTreks, bookings;
  User(
      {this.name,
      this.phone,
      this.email,
      this.bookings,
      this.rentedGear,
      this.savedTreks});

  factory User.fromMap(Map data) {
    return User(
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        bookings: data['bookings'],
        savedTreks: data['savedTreks'],
        rentedGear: data['rentedGear']);
  }
}
