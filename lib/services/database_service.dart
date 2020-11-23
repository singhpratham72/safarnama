import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:safarnama/models/user.dart' as userModel;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final geo = Geoflutterfire();

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference treksRef =
      FirebaseFirestore.instance.collection('Treks');

  Future<void> addUser({String name, String phone}) async {
    List<String> dummyList = [];
    Map<String, dynamic> userData = {
      'name': name,
      'phone': phone,
      'email': _firebaseAuth.currentUser.email,
      'savedTreks': dummyList,
      'rentedGear': dummyList,
      'bookings': dummyList
    };
    return await usersRef.doc(_firebaseAuth.currentUser.uid).set(userData);
  }

  Future<userModel.User> getUser() async {
    var snap = await usersRef.doc(_firebaseAuth.currentUser.uid).get();
    return userModel.User.fromMap(snap.data());
  }

  Stream<userModel.User> userStream() {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .snapshots()
        .map((snap) => userModel.User.fromMap(snap.data()));
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    return await usersRef.doc(_firebaseAuth.currentUser.uid).update(userData);
  }

  Future<void> uploadPicture(String filePath) async {
    File file = File(filePath);

    try {
      await _firebaseStorage
          .ref('profilePictures/${_firebaseAuth.currentUser.uid}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<DocumentReference> addTrek() async {
    DateTime date = DateTime(2021, 1, 7);
    Timestamp trekDate = Timestamp.fromDate(date);
    GeoFirePoint trekPoint = geo.point(latitude: 26.6986, longitude: 88.3117);
    Map<String, dynamic> trekData = {
      'name': 'Insert Trek',
      'price': 14999,
      'altitude': 13685,
      'city': 'Bagdogra',
      'counter': 0,
      'desc':
          'This trek is one of the prettiest meadow treks in our country. At the Dayara meadows, the rolling carpet of grass spreads out far and wide, farther than the eye can see. In winter this carpet of grass turns snow white and stretches out far and wide.',
      'difficulty': 'Moderate',
      'duration': 7,
      'images': [
        'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/treks%2F3.jpg?alt=media&token=3c0f81bc-c6b0-49fe-99c1-010d4fef59fb',
        'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/treks%2F3.jpg?alt=media&token=3c0f81bc-c6b0-49fe-99c1-010d4fef59fb'
      ],
      'pickup': 'Jaubhari',
      'state': 'WB',
      'startDate': trekDate,
      'position': trekPoint.data,
      'type': ''
    };
    return await treksRef.add(trekData);
  }
}
