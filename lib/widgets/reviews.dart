import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_service/screens/doctors_reviews_screen.dart';
import 'package:intl/intl.dart';

import 'new_review.dart';

class Reviews extends StatelessWidget {
  final String doctorID;
  final bool showAll;
  Reviews(this.doctorID, this.showAll);

  void _addNewReview(
    String reviewContent,
    String name,
    String imageUrl,
  ) async {
    await Firestore.instance
        .collection('doctors')
        .document(doctorID)
        .collection('reviews')
        .add({
      'createdAt': Timestamp.now(),
      'creatorImageUrl': imageUrl,
      'creatorName': name,
      'review': reviewContent,
    });
  }

  void _startAddNewReview(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewReview(_addNewReview),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var reviewsCount;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 18,
          top: 18,
          right: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Reviews:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    _startAddNewReview(context);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Write a review!',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            FutureBuilder(
              future: Firestore.instance
                  .collection('doctors')
                  .document(doctorID)
                  .collection('reviews')
                  .getDocuments(),
              builder: (ctx, reviewSnapshot) {
                if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final reviews = reviewSnapshot.data.documents;

                reviewsCount = reviews.length;

                return reviewsCount == 0
                    ? Center(
                        child: Text(
                          'No reviews yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: showAll
                            ? reviews.length
                            : (reviews.length < 1 ? reviews.length : 1),
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: showAll
                                ? null
                                : () {
                                    Navigator.of(context).pushNamed(
                                        DoctorsReviewsScreen.routeName,
                                        arguments: doctorID);
                                  },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Card(
                                elevation: 2,
                                color: Colors.lime[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              reviews[index]['creatorImageUrl'],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                reviews[index]['creatorName'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                DateFormat.yMMMd()
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            reviews[index][
                                                                        'createdAt']
                                                                    .seconds *
                                                                1000))
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(thickness: 2),
                                      Text(
                                        reviews[index]['review'],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
