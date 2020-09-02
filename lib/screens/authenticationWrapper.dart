import 'package:fitbit_for_friends/screens/home/home.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:flutter/material.dart';

import 'authenticate/authenticate.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<LoggedUser> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? Home() : Authenticate();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
