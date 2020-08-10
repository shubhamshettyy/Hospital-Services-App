import 'package:flutter/material.dart';
import 'package:health_service/screens/doctor_appointment_history.dart';
import 'package:health_service/screens/doctor_main_screen.dart';
import 'package:health_service/screens/doctors_reviews_screen.dart';
import 'package:health_service/screens/update_profile.dart';

class AppDrawer extends StatelessWidget {
  final String doctorId;
  final List historyList;
  AppDrawer(this.doctorId, {this.historyList});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Doctor!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.today),
            title: Text('Calendar'),
            onTap: () {
              Navigator.of(context).pushNamed(DoctorMainScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Update Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => UpdateProfile(isUpdate: true),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Reviews'),
            onTap: () {
              Navigator.of(context).pushNamed(DoctorsReviewsScreen.routeName,
                  arguments: doctorId);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.of(context).pushNamed(
                DoctorAppointmentHistoryScreen.routeName,
                arguments: DoctorMainScreen.historyStaticList,
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
