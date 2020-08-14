import 'package:flutter/material.dart';

import '../mainDrawer.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("PROFILE"),
      appBar: AppBar(
          title: Text("Profile")
      ),
      drawer: MainDrawer(),
    );  }
}
