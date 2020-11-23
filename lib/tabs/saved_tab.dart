import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/services/database_service.dart';
import 'package:safarnama/widgets/trek_cards.dart';

class SavedTab extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user.savedTreks.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: FutureBuilder<QuerySnapshot>(
              future: db.treksRef.get(),
              builder: (context, snapshot) {
                // Snap error
                if (snapshot.hasError) return Text('ErrorL ${snapshot.error}');

                //Snap connected
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((trekDoc) {
                      if (user.savedTreks.contains(trekDoc.id)) {
                        Map<String, dynamic> trekData = trekDoc.data();
                        return TrekCardC(
                            id: trekDoc.id,
                            name: trekData['name'],
                            city: trekData['city'],
                            state: trekData['state'],
                            price: trekData['price'],
                            url: trekData['images'][0],
                            difficulty: trekData['difficulty'],
                            duration: trekData['duration']);
                      } else
                        return SizedBox(
                          height: 0.0,
                        );
                    }).toList(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text('You don\'t have any saved treks.'),
          );
  }
}
