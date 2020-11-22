import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/authentication_service.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HOME"),
            Text("${user.name}"),
            Text("${user.phone}"),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
