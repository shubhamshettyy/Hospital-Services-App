import 'package:flutter/material.dart';

class Hospital {
  final String uid;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final String imageurl;
  final String website;
  final String phoneNo;
  final String email;

  Hospital({
    @required this.uid,
    @required this.name,
    @required this.description,
    @required this.lat,
    @required this.lng,
    @required this.imageurl,
    @required this.website,
    @required this.phoneNo,
    @required this.email,
  });
}
