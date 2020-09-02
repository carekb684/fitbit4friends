import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:fitbit_for_friends/screens/home/home.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate extends StatefulWidget {
  final _auth = AuthService();

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
              LoggedUser user =
                await widget._auth.loginWithFacebook(context, clearCache: true);
              if (user != null) {
                //TODO:
                //after loggging, adding user to firestore... NEEDED?
                /*
                var user2 = widget._storeService.fireUserConvert(user);
                widget._storeService.addUser(user2);
                */
                // TODO: prob not needed?
                //Navigator.pushReplacement(context,
                  //MaterialPageRoute(builder: (BuildContext context) => Home()));
          }
        },
      )),
      appBar: AppBar(title: Text("Sign in")),
    );
  }
}
