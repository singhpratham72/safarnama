import 'package:flutter/material.dart';
import 'package:safarnama/constants.dart';

class DisplayDetailsContainer extends StatelessWidget {
  final String text, hintText;
  DisplayDetailsContainer({this.text, @required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              hintText,
              style: greyText,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              margin: EdgeInsets.only(top: 4.0, bottom: 2.0),
              height: 42.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).disabledColor),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0),
              )),
        ],
      ),
    );
  }
}
