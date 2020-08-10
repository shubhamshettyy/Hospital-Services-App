import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewAppointment extends StatefulWidget {
  final BuildContext ctx;
  final Function addNewAppointment;
  final String slot;
  final DateTime time;

  NewAppointment(
    this.ctx,
    this.addNewAppointment,
    this.slot,
    this.time,
  );
  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  final _messageController = TextEditingController();

  void submitData() {
    if (_messageController.text.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    // print(_messageController.text);
    // print(widget.slot);
    // print(widget.time.toString());
    widget.addNewAppointment(
      widget.ctx,
      _messageController.text.trim(),
      widget.slot,
      Timestamp.fromDate(widget.time),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat.yMMMd().format(widget.time) +
                    " (${widget.slot}-${int.parse(widget.slot) + 2})",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Appointment!'),
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              RaisedButton(
                onPressed: submitData,
                child: Text('Add Appointment!'),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
