import 'package:flutter/material.dart';
import 'package:health_service/screens/auth_screen.dart';
import 'package:health_service/screens/doctor_appointment_history.dart';
import 'package:health_service/screens/doctor_detail_screen.dart';
import 'package:health_service/screens/doctor_main_screen.dart';
import 'package:health_service/screens/doctors_reviews_screen.dart';
import 'package:health_service/screens/update_profile.dart';
import 'package:health_service/screens/user_appointment_screen.dart';
import './screens/doctors_list_screen.dart';
import './screens/hospital_screen.dart';
import './screens/hospital_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        accentColorBrightness: Brightness.dark,
      ),
      home: HomeScreen(),
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
        UserAppointmentScreen.routeName: (ctx) => UserAppointmentScreen(),
        DoctorMainScreen.routeName: (ctx) => DoctorMainScreen(),
        HospitalDetailScreen.routeName: (ctx) => HospitalDetailScreen(),
        DoctorsListScreen.routeName: (ctx) => DoctorsListScreen(),
        DoctorDetailScreen.routeName: (ctx) => DoctorsListScreen(),
        DoctorsReviewsScreen.routeName: (ctx) => DoctorsReviewsScreen(),
        DoctorAppointmentHistoryScreen.routeName: (ctx) =>
            DoctorAppointmentHistoryScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, bool>> checkDocExistence(String docId) async {
    bool exists = false;
    bool isSignedIn = false;
    try {
      await Firestore.instance
          .collection('doctors')
          .document(docId)
          .get()
          .then((doc) {
        print('Inside');

        if (doc.exists) {
          isSignedIn = doc.data['isSignedIn'];
          exists = true;
        } else
          exists = false;
      });
      return {'isExist': exists, 'isSignedIn': isSignedIn};
    } catch (e) {
      return {'isExist': exists, 'isSignedIn': isSignedIn};
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, userSnapshot) {
        if (!userSnapshot.hasData) {
          return AuthScreen();
        }
        print('Here');

        if (!AuthScreen.authComplete) {
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
          print('AuthCom false');
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return FutureBuilder(
                future: checkDocExistence(futureSnapshot.data.uid),
                builder: (ctx, boolSnapshot) {
                  if (boolSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return boolSnapshot.data['isExist']
                      ? (boolSnapshot.data['isSignedIn']
                          ? DoctorMainScreen()
                          : UpdateProfile(
                              isUpdate: false,
                            ))
                      : HospitalScreen();
                });
          },
        );
      },
    );
  }
}
