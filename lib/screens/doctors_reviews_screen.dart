import 'package:flutter/material.dart';
import '../widgets/reviews.dart';

class DoctorsReviewsScreen extends StatelessWidget {
  static const routeName = '/all-reviews';
  @override
  Widget build(BuildContext context) {
    final doctorId = ModalRoute.of(context).settings.arguments as String;
    final bool showAll = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews of'),
      ),
      body: Reviews(doctorId, showAll),
    );
  }
}
