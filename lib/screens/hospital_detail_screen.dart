import 'package:flutter/material.dart';
import '../widgets/hospital_location.dart';
import '../models/hospital.dart';
import 'package:url_launcher/url_launcher.dart';

import 'doctors_list_screen.dart';

class HospitalDetailScreen extends StatelessWidget {
  static const routeName = '/hospital-detail-screen';

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospital = ModalRoute.of(context).settings.arguments as Hospital;
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: hospital.email,
      queryParameters: {'subject': 'Put Some subject here!'},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hospital.name,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                hospital.imageurl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        return _makePhoneCall('tel:${hospital.phoneNo}');
                      },
                    ),
                    Text('Call'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.public),
                      onPressed: () {
                        return _launchInBrowser(hospital.website);
                      },
                    ),
                    Text('Website'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.email),
                      onPressed: () {
                        return launch(_emailLaunchUri.toString());
                      },
                    ),
                    Text('Email'),
                  ],
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(25),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    hospital.description,
                    style: TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
            ),
            HospitalLocation(
              hospital.lat,
              hospital.lng,
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 45,
                  child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          DoctorsListScreen.routeName,
                          arguments: hospital.uid);
                    },
                    icon: Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View Our Doctors',
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
          ],
        ),
      ),
    );
  }
}
