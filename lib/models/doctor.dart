import 'package:flutter/cupertino.dart';

class Doctor {
  final String uid;
  final String name;
  final String email;
  final String contact;
  final String imageurl;
  final String type;
  final String experience;
  final String about;
  final double fee;
  final String education;

  Doctor({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.contact,
    @required this.imageurl,
    @required this.type,
    @required this.experience,
    @required this.about,
    @required this.fee,
    @required this.education,
  });
}
