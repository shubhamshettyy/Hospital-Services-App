import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatefulWidget {
  final List<dynamic> slotList;
  final String slotTime;

  AppointmentCard(this.slotList, this.slotTime);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 6,
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                widget.slotTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  // vertical: 4,
                ),
                height: min(widget.slotList.length * 55.0 + 30.0, 350),
                child: widget.slotList.length == 0
                    ? Text(
                        'No appointments yet!',
                      )
                    : ListView(
                        children: widget.slotList
                            .map<Widget>((docSnapshot) => FutureBuilder(
                                  future: Firestore.instance
                                      .collection('users')
                                      .document(docSnapshot['userId'])
                                      .get(),
                                  builder: (ctx, userSnapshot) {
                                    final userData = userSnapshot.data;

                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          userData['image_url'],
                                        ),
                                      ),
                                      title: Text(
                                        userData['name'],
                                      ),
                                      subtitle: Text(
                                          docSnapshot['appointmentSubject']),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
              )
          ],
        ),
      ),
    );
  }
}
