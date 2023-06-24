import 'package:firebase_auth/firebase_auth.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String email, String password, String name, String phone}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      DatabaseService databaseService = DatabaseService();
      await databaseService.addUser(name: name, phone: phone);
      await _firebaseAuth.currentUser.updatePhotoURL(
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
      _firebaseAuth.currentUser.updatePhotoURL(googleUser.photoUrl);
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
