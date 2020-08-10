import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentHistoryScreen extends StatelessWidget {
  static const routeName = '/doctor-appointment-history';
  @override
  Widget build(BuildContext context) {
    var historyList = ModalRoute.of(context).settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Apointments'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (ctx, index) {
          return FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(historyList[index]['userId'])
                .get(),
            builder: (ctx, userSnapshot) {
              final userData = userSnapshot.data;

              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        userData['image_url'],
                      ),
                    ),
                    title: Text(
                      userData['name'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(historyList[index]['appointmentSubject']),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              historyList[index]['time'].seconds * 1000)),
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
