import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safarnama/models/user.dart' as userModel;

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

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
}
