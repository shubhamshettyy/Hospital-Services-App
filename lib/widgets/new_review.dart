import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewReview extends StatefulWidget {
  final Function _addNewReview;
  NewReview(this._addNewReview);

  @override
  _NewReviewState createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  var name = '';
  var imageUrl = '';
  final _reviewController = TextEditingController();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) {
        print(value.data);
        name = value.data['name'];
        imageUrl = value.data['image_url'];
        print(name);
      });
    });

    super.initState();
  }

  void submitData() {
    if (_reviewController.text.isEmpty) {
      // showDialog(context: context,child:Text(''));
      Navigator.of(context).pop();
      return;
    }

    widget._addNewReview(
      _reviewController.text.trim(),
      name,
      imageUrl,
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
                'Add a new Review!',
                style: TextStyle(
                  color: Colors.pink,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Review!'),
                controller: _reviewController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              RaisedButton(
                onPressed: submitData,
                child: Text('Add Review!'),
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
