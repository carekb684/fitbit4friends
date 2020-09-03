import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:flutter/material.dart';

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
        },
      )),
      appBar: AppBar(title: Text("Sign in")),
    );
  }
}
