import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/models/user.dart';
import 'package:safarnama/screens/trek_screen.dart';
import 'package:safarnama/services/database_service.dart';

import '../constants.dart';

//Small Trek Card
class TrekCardA extends StatelessWidget {
  final String id, name, url, city, state;
  final int price;
  final double rating;

  TrekCardA(
      {this.id,
      this.name,
      this.city,
      this.state,
      this.url,
      this.price,
      this.rating = 4.5});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                  value: user,
                  child: TrekScreen(
                    trekID: id,
                  )),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 20.0),
        height: 182.0,
        width: 135.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.15),
                  spreadRadius: 2.0,
                  blurRadius: 10.0,
                  offset: Offset(9, 9))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(url))),
                height: 120.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                color: Colors.white,
                height: 62.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: cardText,
                        ),
                      ),
                      Text(
                        '$city, $state',
                        style: greyText.copyWith(fontSize: 11.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹$price',
                            style: highlightText,
                          ),
                          Text(
                            '$rating\u2605',
                            style: highlightText,
                          )
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Large Trek Card
class TrekCardB extends StatelessWidget {
  final String id, name, url, city, state, difficulty;
  final int price, duration;

  TrekCardB(
      {this.id,
      this.name,
      this.city,
      this.state,
      this.url,
      this.price,
      this.difficulty,
      this.duration});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      height: 124.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF000000).withOpacity(0.15),
                spreadRadius: 2.0,
                blurRadius: 10.0,
                offset: Offset(9, 9))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(url))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: cardText.copyWith(fontSize: 16.0),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12.0,
                        color: Color(0xFFC1C1C1),
                      ),
                      Text(
                        '$city, $state',
                        style: greyText.copyWith(fontSize: 12.0),
                      ),
                    ],
                  ),
                  Text(
                    '₹$price',
                    style: highlightText.copyWith(fontSize: 14.0),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.signal_cellular_alt,
                            color: Theme.of(context).accentColor,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Difficulty',
                                style: headingText.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$difficulty',
                                style: headingText.copyWith(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Theme.of(context).accentColor,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: headingText.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$duration Days',
                                style: headingText.copyWith(
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: user,
                          child: TrekScreen(
                            trekID: id,
                          )),
                    ));
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                width: 46.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Transform.rotate(
                  angle: 270 * 3.1415927 / 180,
                  child: Text(
                    'View',
                    style: buttonText.copyWith(
                        fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Saved Trek Card
class TrekCardC extends StatelessWidget {
  final String id, name, url, city, state, difficulty;
  final int price, duration;

  TrekCardC(
      {this.id,
      this.name,
      this.city,
      this.state,
      this.url,
      this.price,
      this.difficulty,
      this.duration});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                  value: user,
                  child: TrekScreen(
                    trekID: id,
                  )),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
        padding: EdgeInsets.only(right: 16.0),
        height: 124.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.15),
                  spreadRadius: 2.0,
                  blurRadius: 10.0,
                  offset: Offset(9, 9))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(url))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: cardText.copyWith(fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.0,
                          color: Color(0xFFC1C1C1),
                        ),
                        Text(
                          '$city, $state',
                          style: greyText.copyWith(fontSize: 12.0),
                        ),
                      ],
                    ),
                    Text(
                      '₹$price',
                      style: highlightText.copyWith(fontSize: 14.0),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt,
                              color: Theme.of(context).accentColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Difficulty',
                                  style: headingText.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$difficulty',
                                  style: headingText.copyWith(
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Theme.of(context).accentColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration',
                                  style: headingText.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$duration Days',
                                  style: headingText.copyWith(
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  user.savedTreks.remove(id);
                  await db.updateUser(user.getUserMap());
                },
                icon: Icon(
                  Icons.delete_sharp,
                  size: 32.0,
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
