import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_detail_screen.dart';
import '../models/doctor.dart';

class DoctorsListScreen extends StatelessWidget {
  static const routeName = '/doctors-list-screen';

  @override
  Widget build(BuildContext context) {
    final hospitalUid = ModalRoute.of(context).settings.arguments as String;

    final DocumentReference docRef =
        Firestore.instance.collection('hospitals').document(hospitalUid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Doctors'),
      ),
      body: FutureBuilder(
        future: Firestore.instance
            .collection('doctors')
            .where(
              "hospital",
              isEqualTo: docRef,
            )
            .getDocuments(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final doctorDocs = futureSnapshot.data.documents;
          return ListView.builder(
            itemCount: doctorDocs.length,
            itemBuilder: (ctx, index) {
              final doctor = Doctor(
                uid: doctorDocs[index].documentID,
                name: doctorDocs[index]['name'],
                email: doctorDocs[index]['email'],
                contact: doctorDocs[index]['contact'],
                imageurl: doctorDocs[index]['imageurl'],
                type: doctorDocs[index]['type'],
                experience: doctorDocs[index]['experience'],
                about: doctorDocs[index]['about'],
                fee: double.parse(doctorDocs[index]['fee']),
                education: doctorDocs[index]['education'],
              );
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DoctorDetailScreen(doctor),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        doctorDocs[index]['imageurl'],
                      ),
                    ),
                    title: Text(
                      doctorDocs[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      doctorDocs[index]['type'],
                    ),
                    trailing: Text(
                      '\u20B9 ${doctorDocs[index]['fee']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
