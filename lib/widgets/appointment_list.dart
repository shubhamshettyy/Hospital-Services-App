import 'package:flutter/material.dart';
import 'package:health_service/widgets/appointment_card.dart';

class AppointmentList extends StatefulWidget {
  final Map<String, dynamic> dayList;

  AppointmentList(this.dayList);
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  var slotList = [
    '10AM - 12PM',
    '1PM - 3PM',
    '3PM - 5PM',
    '5PM - 7PM',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        AppointmentCard(
          widget.dayList['10'],
          slotList[0],
        ),
        AppointmentCard(
          widget.dayList['1'],
          slotList[1],
        ),
        AppointmentCard(
          widget.dayList['3'],
          slotList[2],
        ),
        AppointmentCard(
          widget.dayList['5'],
          slotList[3],
        ),
      ],
    );
  }
}
