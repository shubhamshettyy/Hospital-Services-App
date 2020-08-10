import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_service/pickers/user_image_picker.dart';
import 'package:health_service/screens/doctor_main_screen.dart';

class UpdateProfile extends StatefulWidget {
  final bool isUpdate;

  UpdateProfile({
    this.isUpdate,
  });
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _experienceFocusNode = FocusNode();
  final _feeFocusNode = FocusNode();
  final _aboutFocusNode = FocusNode();
  final _educationFocusNode = FocusNode();
  final _hospitalFocusNode = FocusNode();
  bool isImageSelected = false;

  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
    isImageSelected = true;
  }

  Map<String, dynamic> _initValues = {
    'name': '',
    'email': '',
    'contact': '',
    'imageurl': '',
    'type': '',
    'experience': '',
    'fee': '',
    'about': "",
    'education': '',
    'hospital': '',
  };

  Map<String, dynamic> _submitValues = {
    'name': '',
    'email': '',
    'contact': '',
    'imageurl': '',
    'type': '',
    'experience': '',
    'fee': '',
    'about': "",
    'education': '',
    'hospital': '',
    'isSignedIn': true,
  };

  var _isLoading = false;
  String currentUserId = '';

  String _selectedHospital = 'h7TslvuiH6IeoaXlNbmB';

  List<DropdownMenuItem<String>> hospitalList = [];
  List<DropdownMenuItem<String>> doctorTypeList = [
    DropdownMenuItem(
      child: Text('Dentist'),
      value: 'Dentist',
    ),
    DropdownMenuItem(
      child: Text('Gynecologist/obstetrician'),
      value: 'Gynecologist/obstetrician',
    ),
    DropdownMenuItem(
      child: Text('General Physician'),
      value: 'General Physician',
    ),
    DropdownMenuItem(
      child: Text('Dermatologist'),
      value: 'Dermatologist',
    ),
    DropdownMenuItem(
      child: Text('ENT Specialist'),
      value: 'ENT Specialist',
    ),
    DropdownMenuItem(
      child: Text('Homeopath'),
      value: 'Homeopath',
    ),
    DropdownMenuItem(
      child: Text('Ayurveda'),
      value: 'Ayurveda',
    ),
  ];

  String _selectedDoctorType = 'Dentist';
  DocumentReference docRef;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    docRef = Firestore.instance
        .collection('hospitals')
        .document(_submitValues['hospital']);
    _submitValues['hospital'] = docRef;

    if (widget.isUpdate && isImageSelected) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(currentUserId + '.jpg');

      await ref.putFile(_userImageFile).onComplete;

      final url = await ref.getDownloadURL();

      _submitValues['imageurl'] = url.toString();
    }

    print(_submitValues);
    await Firestore.instance
        .collection('doctors')
        .document(currentUserId)
        .setData(_submitValues);
    // print(_userImageFile);
    //print(_submitValues);

    Navigator.of(context).pushReplacementNamed(DoctorMainScreen.routeName);
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Firestore.instance
        .collection('hospitals')
        .getDocuments()
        .then((futureSnapshot) {
      hospitalList = [];
      futureSnapshot.documents.map((hospitalMap) {
        print(hospitalMap['name']);
        print(hospitalMap.documentID);
        hospitalList.add(DropdownMenuItem(
          child: Text(hospitalMap['name']),
          value: hospitalMap.documentID,
        ));
      }).toList();
    });

    if (widget.isUpdate) {
      FirebaseAuth.instance.currentUser().then((user) {
        currentUserId = user.uid;
        Firestore.instance
            .collection('doctors')
            .document(user.uid)
            .get()
            .then((docSnapshot) {
          _initValues['name'] = docSnapshot.data['name'];
          _initValues['email'] = docSnapshot.data['email'];
          _initValues['contact'] = docSnapshot.data['contact'];
          _initValues['imageurl'] = docSnapshot.data['imageurl'];
          _initValues['type'] = docSnapshot.data['type'];
          _initValues['experience'] = docSnapshot.data['experience'];
          _initValues['fee'] = docSnapshot.data['fee'];
          _initValues['about'] = docSnapshot.data['about'];
          _initValues['education'] = docSnapshot.data['education'];
          _submitValues['imageurl'] = docSnapshot.data['imageurl'];
          _submitValues['type'] = _initValues['type'];
          _selectedDoctorType = docSnapshot.data['type'];
          print(_initValues['type'] + " type check");
          _submitValues['hospital'] =
              docSnapshot.data['hospital'].path.split('/')[1];
          _selectedHospital = docSnapshot.data['hospital'].path.split('/')[1];
          print(docSnapshot.data['hospital']);
          setState(() {
            _isLoading = false;
          });
        });
      });
    } else {
      FirebaseAuth.instance.currentUser().then((user) {
        currentUserId = user.uid;
        Firestore.instance
            .collection('doctors')
            .document(user.uid)
            .get()
            .then((docSnapshot) {
          _initValues['name'] = docSnapshot.data['name'];
          _initValues['email'] = docSnapshot.data['email'];
          _initValues['imageurl'] = docSnapshot.data['imageurl'];
          _submitValues['imageurl'] = docSnapshot.data['imageurl'];
          setState(() {
            _isLoading = false;
          });
        });

        print(_initValues);
      });
      FirebaseAuth.instance.currentUser().then((user) {
        currentUserId = user.uid;
        Firestore.instance
            .collection('doctors')
            .document(user.uid)
            .get()
            .then((docSnapshot) {
          _initValues['name'] = docSnapshot.data['name'];
          _initValues['email'] = docSnapshot.data['email'];
          _initValues['imageurl'] = docSnapshot.data['imageurl'];
          setState(() {
            _isLoading = false;
          });
        });

        print(_initValues);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isUpdate ? 'Update Profile' : 'Set Up Profile',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    if (widget.isUpdate)
                      UserImagePicker(
                        _pickedImage,
                        sentPickedImage: _initValues['imageurl'],
                      ),
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['name'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_contactFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['email'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['contact'],
                      decoration: InputDecoration(
                        labelText: 'Contact',
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: _contactFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_typeFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a contact';
                        }
                        if (value.length != 10) {
                          return 'Should be 10 digits long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['contact'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['experience'],
                      decoration: InputDecoration(
                        labelText: 'Experience (in years)',
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: _experienceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_feeFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter experience in years';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['experience'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['fee'],
                      decoration: InputDecoration(
                        labelText: 'Fee per visit (in Rupees)',
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: _feeFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_aboutFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter fee!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['fee'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['about'],
                      decoration: InputDecoration(
                        labelText: 'Enter your bio',
                      ),
                      focusNode: _aboutFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_educationFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your bio!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['about'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['education'],
                      decoration: InputDecoration(
                        labelText: 'Enter your Education',
                      ),
                      focusNode: _educationFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_hospitalFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Education!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _submitValues['education'] = value;
                      },
                    ),
                    DropdownButton(
                      hint: new Text('Select Type'),
                      items: doctorTypeList,
                      value: _selectedDoctorType,
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctorType = value;
                          _submitValues['type'] = _selectedDoctorType;
                        });
                      },
                      isExpanded: true,
                    ),
                    DropdownButton(
                      hint: new Text('Select Hospital'),
                      items: hospitalList,
                      value: _selectedHospital,
                      onChanged: (value) {
                        setState(() {
                          _selectedHospital = value;
                          _submitValues['hospital'] = value;
                        });
                      },
                      isExpanded: true,
                    ),
                    RaisedButton(
                      onPressed: _saveForm,
                      child: Text('Submit!'),
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
