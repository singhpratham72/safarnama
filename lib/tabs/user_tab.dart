import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/constants.dart';
import 'package:safarnama/models/user.dart' as userModel;
import 'package:safarnama/screens/booking_history_screen.dart';
import 'package:safarnama/services/authentication_service.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/displayDetails_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserTab extends StatelessWidget {
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel.User>(context);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 36.0),
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(
                          (MediaQuery.of(context).size.width / 2), 75.0),
                      bottomRight: Radius.elliptical(
                          (MediaQuery.of(context).size.width / 2), 75.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      print(FirebaseAuth.instance.currentUser.photoURL);
                      // getImage();
                    },
                    child: Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(FirebaseAuth
                                  .instance.currentUser.photoURL ??
                              'https://firebasestorage.googleapis.com/v0/b/safarnama-9b3f1.appspot.com/o/users%2Fanonymous.jpg?alt=media&token=3a3df200-04f6-43d3-87eb-a33fa4c3b7b4'),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    user.name,
                    style: headingText.copyWith(
                        color: Colors.white, fontSize: 32.0),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTileTheme(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      child: Theme(
                        data: theme,
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.only(
                              right: 8.0, top: 0.0, bottom: 0.0),
                          childrenPadding: EdgeInsets.only(bottom: 0.0),
                          title: Text(
                            "Account",
                            style: headingText,
                          ),
                          children: [
                            DisplayDetailsContainer(
                              text: user.name,
                              hintText: "Name",
                            ),
                            DisplayDetailsContainer(
                              text: user.phone,
                              hintText: "Phone",
                            ),
                            DisplayDetailsContainer(
                              text: user.email,
                              hintText: "E-mail",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      color: Theme.of(context).disabledColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                        value: user,
                                        child: BookingHistoryScreen(),
                                      )));
                        },
                        child: Text(
                          "Bookings",
                          style: headingText,
                        ),
                      ),
                    ),
                    // Divider(
                    //   height: 20.0,
                    //   color: Theme.of(context).disabledColor,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Text(
                    //       "Test Button",
                    //       style: headingText,
                    //     ),
                    //   ),
                    // ),
                    Divider(
                      height: 20.0,
                      color: Theme.of(context).disabledColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, right: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final bool connected = await db.checkGoogleConnect();

                          if (!connected) {
                            String message = await context
                                .read<AuthenticationService>()
                                .linkGoogleAccount();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              padding:
                                  EdgeInsets.only(bottom: 16.0, left: 20.0),
                              content: Text(message),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              padding:
                                  EdgeInsets.only(bottom: 16.0, left: 20.0),
                              content: Text(
                                  'Your account is already connected to Google.'),
                            ));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Connect with Google',
                              style: headingText,
                            ),
                            Icon(FontAwesomeIcons.google,
                                color: Theme.of(context).accentColor),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      color: Theme.of(context).disabledColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          context.read<AuthenticationService>().signOut();
                        },
                        child: Text(
                          "Sign out",
                          style: headingText.copyWith(
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
