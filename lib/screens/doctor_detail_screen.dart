import 'package:flutter/material.dart';
import 'package:health_service/screens/user_appointment_screen.dart';
import '../models/doctor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/reviews.dart';

class DoctorDetailScreen extends StatelessWidget {
  static const routeName = '/doctor-detail-screen';
  final Doctor doctor;
  DoctorDetailScreen(this.doctor);

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: doctor.email,
      queryParameters: {'subject': 'Put Some subject here!'},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 18,
                      bottom: 18,
                      left: 18,
                      right: 18,
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(doctor.imageurl),
                          radius: 60,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                doctor.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                doctor.education,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '${doctor.experience} of Experience',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                            onPressed: () {
                              return _makePhoneCall('tel:${doctor.contact}');
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.email),
                            onPressed: () {
                              return launch(_emailLaunchUri.toString());
                            },
                            label: Text('Email'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'About:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(doctor.about),
                      ],
                    ),
                  ),
                  Reviews(doctor.uid, false),

                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
            height: 45,
            child: RaisedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  UserAppointmentScreen.routeName,
                  arguments: doctor.uid,
                );
              },
              icon: Icon(
                Icons.local_hospital,
                color: Colors.white,
              ),
              label: Text(
                'Make an appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
