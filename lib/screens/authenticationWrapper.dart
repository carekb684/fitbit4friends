import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbit_for_friends/screens/authenticate/authenticate.dart';
import 'package:fitbit_for_friends/screens/home/home.dart';
import 'file:///C:/Users/calle/AndroidStudioProjects/fitbit_for_friends/lib/services/firebase/authService.dart';
import 'package:flutter/material.dart';

class AuthenticationWrapper extends StatefulWidget {

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {


  @override
  Widget build(BuildContext context) {
    // TODO : return home or authentiation widget

   return Authenticate();

   //return Home(onSignedOut: _SignedOut);
  }
}
