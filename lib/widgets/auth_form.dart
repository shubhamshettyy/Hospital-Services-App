import 'dart:io';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
    String regNo,
    bool isDoctorLogin,
  ) submitFn;

  final bool _isLoading;

  AuthForm(this.submitFn, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _isDoctorLogin = false;

  var _userEmail = '';
  var _name = '';
  var _userPassword = '';
  var _userImageFile;
  var _regNo = '';

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Pick an image!',
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
    }
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      _name.trim(),
      _userImageFile,
      _isLogin,
      context,
      _regNo.trim(),
      _isDoctorLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Full Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Full Name must be atleast 4 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Full name',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  if (!_isLogin && _isDoctorLogin)
                    TextFormField(
                      key: ValueKey('Registration Number'),
                      validator: (value) {
                        if (value.isEmpty || value.length != 8) {
                          return 'Registration number must be 8 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _regNo = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                      ),
                    ),
                  SizedBox(height: 12),
                  if (!widget._isLoading)
                    RaisedButton(
                      textTheme: ButtonTextTheme.primary,
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create a New Account!'
                            : 'Already have an account?',
                      ),
                      textColor: Theme.of(context).primaryColor,
                    ),
                  if (!widget._isLoading && !_isLogin)
                    SwitchListTile(
                      title: Text(
                        'Are you a Doctor?',
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                      value: _isDoctorLogin,
                      onChanged: (value) {
                        setState(
                          () {
                            _isDoctorLogin = !_isDoctorLogin;
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
