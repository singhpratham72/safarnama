import 'package:flutter/material.dart';
import 'package:safarnama/constants.dart';
import 'package:safarnama/services/database_service.dart';

String review = "";
int selectedRating = 5;

class AddReview extends StatelessWidget {
  final Function setState;
  final DatabaseService db = DatabaseService();
  final String trekID, userName;
  AddReview(
      {@required this.trekID,
      @required this.userName,
      @required this.setState});
  @override
  Widget build(BuildContext context) {
    review = "";
    selectedRating = 5;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Color(0xff757575),
        ),
        child: Container(
          height: 350.0,
          padding: EdgeInsets.only(top: 25.0, bottom: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Rate ',
                          style: headingText.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 24.0),
                          children: [
                            TextSpan(
                                text: 'this trek',
                                style: TextStyle(color: Colors.black))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ReviewRating(
                        onSelected: (rating) {
                          selectedRating = rating;
                        },
                      ),
                    ),
                    EditReviewContainer(),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await db.addReview(
                        trekID: trekID,
                        rating: selectedRating,
                        review: review,
                        name: userName);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your review has been added.'),
                    ));
                    setState();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(
                      'Submit',
                      style: buttonText.copyWith(fontSize: 18.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditReviewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 35.0),
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.secondary,
        decoration: InputDecoration(
          focusColor: Colors.grey,
          border: OutlineInputBorder(),
          labelText: 'Write your review here.',
        ),
        onChanged: (newText) {
          review = newText;
        },
      ),
    );
  }
}

class ReviewRating extends StatefulWidget {
  final Function(int) onSelected;
  ReviewRating({this.onSelected});

  @override
  _ReviewRatingState createState() => _ReviewRatingState();
}

class _ReviewRatingState extends State<ReviewRating> {
  int _selected = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () {
              widget.onSelected(i);
              setState(() {
                _selected = i;
              });
            },
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: _selected == i
                    ? Theme.of(context).colorScheme.secondary
                    : Color(0xFFDCDCDC),
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Text(
                "$i",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selected == i ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          )
      ],
    );
  }
}
