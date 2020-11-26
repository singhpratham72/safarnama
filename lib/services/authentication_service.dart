import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signUp(
      {String email, String password, String name, String phone}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      DatabaseService databaseService = DatabaseService();
      await databaseService.addUser(name: name, phone: phone);
      await _firebaseAuth.currentUser.updateProfile(
          photoURL:
              'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/users%2Fanonymous.jpg?alt=media&token=3a3df200-04f6-43d3-87eb-a33fa4c3b7b4');
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> linkGoogleAccount() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleCredentials =
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      _firebaseAuth.currentUser.linkWithCredential(googleCredentials);
      _firebaseAuth.currentUser.updateProfile(photoURL: googleUser.photoUrl);
      return 'Your account has been connected to Google.';
    } catch (e) {
      print(e.toString());
      return 'There was an error. Please try again.';
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      List<String> signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      print(signInMethods);

      // Once signed in, return the UserCredential
      if (signInMethods.contains('password')) {
        await _firebaseAuth.signInWithCredential(credential);
        return null;
      } else
        return 'User does not exist. Sign up.';
    } catch (e) {
      print(e.toString());
      return ('An error occurred. Please try again.');
    }
  }
}
