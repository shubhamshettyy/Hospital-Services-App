import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_service/widgets/new_appointment.dart';
import 'package:intl/intl.dart';

class UserAppointmentScreen extends StatefulWidget {
  static const routeName = '/user-appointment-screen';

  @override
  _UserAppointmentScreenState createState() => _UserAppointmentScreenState();
}

class _UserAppointmentScreenState extends State<UserAppointmentScreen> {
  final DateTime today = DateTime.now();

  BuildContext snackbarContext;

  final DateTime tomorrow = DateTime.now().add(
    new Duration(days: 1),
  );

  final DateTime dayAfterTomorrow = DateTime.now().add(
    new Duration(days: 2),
  );
  var todayList;
  var tomorrowList;
  var dayAfterTomorrowList;

  String doctorId;

  void segregateAppointments(List<DocumentSnapshot> appointmentDocs) {
    todayList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };
    tomorrowList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };
    dayAfterTomorrowList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };

    appointmentDocs.forEach((doc) {
      if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(today)) {
        todayList[doc['slot']] += 1;
      } else if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(tomorrow)) {
        tomorrowList[doc['slot']] += 1;
      } else if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(dayAfterTomorrow)) {
        dayAfterTomorrowList[doc['slot']] += 1;
      } else {}
    });
  }

  void _addNewAppointment(
    BuildContext ctx,
    String message,
    String slot,
    Timestamp time,
  ) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    QuerySnapshot userAppointmentDocs = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('appointments')
        .getDocuments();

    var flag = true;

    userAppointmentDocs.documents.forEach((doc) {
      String userAppointmentTime = DateFormat.yMMMd().format(
          DateTime.fromMillisecondsSinceEpoch(doc['time'].seconds * 1000));

      if ((userAppointmentTime ==
              DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000))) &&
          doctorId == doc['doctorId'] &&
          flag) {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'You have already booked an appointment!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        );
        flag = false;
      }
    });

    if (flag) {
      await Firestore.instance
          .collection('doctors')
          .document(doctorId)
          .collection('appointments')
          .add({
        'appointmentSubject': message,
        'slot': slot,
        'userId': currentUser.uid,
        'time': time,
      });

      await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .collection('appointments')
          .add({
        'appointmentSubject': message,
        'slot': slot,
        'doctorId': doctorId,
        'time': time,
      });
    }
  }

  void _startAddNewAppointment(
    BuildContext ctx,
    String slot,
    DateTime time,
  ) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewAppointment(
            ctx,
            _addNewAppointment,
            slot,
            time,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    snackbarContext = context;
    doctorId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Appointment!'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('doctors')
              .document(doctorId)
              .collection('appointments')
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final appointmentDocs = streamSnapshot.data.documents;

            segregateAppointments(appointmentDocs);

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(today),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '10 AM - 12 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['10'] < 3) && (today.hour < 10)
                                        ? () {}
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['1'] < 3) && (today.hour < 13)
                                        ? () {
                                            _startAddNewAppointment(
                                              context,
                                              '1',
                                              today,
                                            );
                                          }
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['3'] < 3) && (today.hour < 15)
                                        ? () {
                                            _startAddNewAppointment(
                                              context,
                                              '3',
                                              today,
                                            );
                                          }
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['5'] < 3) && (today.hour < 17)
                                        ? () {
                                            _startAddNewAppointment(
                                              context,
                                              '5',
                                              today,
                                            );
                                          }
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(tomorrow),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                  child: Text(
                                    '10 AM - 12 PM',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: (tomorrowList['10'] < 3)
                                      ? () {
                                          _startAddNewAppointment(
                                            context,
                                            '10',
                                            tomorrow,
                                          );
                                        }
                                      : null,
                                  color: Colors.blue),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (tomorrowList['1'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '1',
                                          tomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (tomorrowList['3'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '3',
                                          tomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (tomorrowList['5'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '5',
                                          tomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(dayAfterTomorrow),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                  child: Text(
                                    '10 AM - 12 PM',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: (dayAfterTomorrowList['10'] < 3)
                                      ? () {
                                          _startAddNewAppointment(
                                            context,
                                            '10',
                                            dayAfterTomorrow,
                                          );
                                        }
                                      : null,
                                  color: Colors.blue),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['1'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '1',
                                          dayAfterTomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['3'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '3',
                                          dayAfterTomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['5'] < 3)
                                    ? () {
                                        _startAddNewAppointment(
                                          context,
                                          '5',
                                          dayAfterTomorrow,
                                        );
                                      }
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
