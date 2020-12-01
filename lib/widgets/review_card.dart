import 'package:flutter/material.dart';
import 'package:safarnama/constants.dart';

class ReviewCard extends StatelessWidget {
  final String review, name;
  final int rating;
  ReviewCard({this.review, this.name, this.rating});
  @override
  Widget build(BuildContext context) {
    String reviewStars = "";
    for (int i = 0; i < rating; i++) {
      reviewStars = reviewStars + '\u2605';
    }
    return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Theme.of(context).disabledColor)),
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '$name ',
                style: greyText.copyWith(color: Colors.black87),
              ),
              Icon(
                Icons.check_circle_rounded,
                size: 16.0,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          Text(
            '$reviewStars',
            style: headingText.copyWith(
                color: Theme.of(context).accentColor, fontSize: 16.0),
          ),
          Text(
            review,
            style: greyText,
          )
        ]));
  }
}
