import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_service/widgets/app_drawer.dart';
import 'package:health_service/widgets/appointment_list.dart';
import 'package:intl/intl.dart';

import 'auth_screen.dart';

class DoctorMainScreen extends StatefulWidget {
  static const routeName = '/doctor-main-screen';
  static List<DocumentSnapshot> historyStaticList = [];

  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  String doctorId;
  final DateTime today = DateTime.now();

  final DateTime tomorrow = DateTime.now().add(
    new Duration(days: 1),
  );

  final DateTime dayAfterTomorrow = DateTime.now().add(
    new Duration(days: 2),
  );

  var todayList;

  var tomorrowList;

  var dayAfterTomorrowList;

  var historyList = [];

  var isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth.instance.currentUser().then((value) {
      doctorId = value.uid;
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  void segregateAppointments(List<DocumentSnapshot> appointmentDocs) {
    todayList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };
    tomorrowList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };
    dayAfterTomorrowList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };
    historyList = [];
    DoctorMainScreen.historyStaticList = [];

    appointmentDocs.forEach(
      (doc) {
        if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(today)) {
          todayList[doc['slot']].add(doc);
        } else if (DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(
                    doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(tomorrow)) {
          tomorrowList[doc['slot']].add(doc);
        } else if (DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(
                    doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(dayAfterTomorrow)) {
          dayAfterTomorrowList[doc['slot']].add(doc);
        } else {
          historyList.add(doc);
          DoctorMainScreen.historyStaticList.add(doc);
        }
      },
    );
    print(todayList);
    print(tomorrowList);
    print(dayAfterTomorrowList);
    print(historyList);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Today',
              ),
              Tab(
                text: 'Tomorrow',
              ),
              Tab(
                text: 'Day After',
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AuthScreen.routeName, (route) {
                  return false;
                });
              },
            ),
          ],
        ),
        drawer: AppDrawer(
          doctorId,
          historyList: historyList,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('doctors')
                    .document(doctorId)
                    .collection('appointments')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final appointmentDocs = streamSnapshot.data.documents;

                  segregateAppointments(appointmentDocs);

                  return TabBarView(
                    children: <Widget>[
                      AppointmentList(todayList),
                      AppointmentList(tomorrowList),
                      AppointmentList(dayAfterTomorrowList),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
