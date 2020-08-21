import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:fitbit_for_friends/screens/home/home.dart';
import 'file:///C:/Users/calle/AndroidStudioProjects/fitbit_for_friends/lib/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate extends StatefulWidget {

  final _auth = AuthService();
  final _storeService = FirestoreService();
  SharedPreferences sPrefs;

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: RaisedButton(
              child: Text("Sign in with Facebook"),
      onPressed: () async {
        widget.sPrefs = await SharedPreferences.getInstance();
        bool clearCache = widget.sPrefs.getString("email") == null ? true : false;
        fire.User user = await widget._auth.loginWithFacebook(context, clearCache);
        if (user != null) {
          var user2 = widget._storeService.fireUserConvert(user);
          widget._storeService.addUser(user2);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
        }
      },
    )
        ),
      appBar: AppBar(
        title: Text("Sign in")
      ),
    );
  }
}
