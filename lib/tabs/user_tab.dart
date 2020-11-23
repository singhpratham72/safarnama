import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/constants.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/authentication_service.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/displayDetails_widget.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    DatabaseService db = DatabaseService();

    // //To get image from device gallery
    // Future<void> getImage() async {
    //   final imagePicker = ImagePicker();
    //   final pickedImage =
    //       await imagePicker.getImage(source: ImageSource.gallery);
    //   await db.uploadPicture(pickedImage.path);
    // }

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
                    onLongPress: () {
                      // getImage();
                    },
                    child: Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
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
                            )
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
                          // await db.addTrek();
                          // print('Trek Added');
                        },
                        child: Text(
                          "Bookings",
                          style: headingText,
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
                          // user.name = 'Kashvi';
                          // db.updateUser(user.getUserMap());
                        },
                        child: Text(
                          "Gear Rentals",
                          style: headingText,
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
