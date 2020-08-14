import 'package:flutter/material.dart';
import 'package:fitbit_for_friends/screens/mainDrawer.dart';

class Home extends StatelessWidget {

  Home({this.onSignedOut});
  VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("HOME"),
      appBar: AppBar(
        title: Text("Home")
      ),
      drawer: MainDrawer(onSignedOut: onSignedOut),
    );
  }
}
