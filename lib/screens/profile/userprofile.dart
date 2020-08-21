import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/profileheader.dart';
import 'package:flutter/material.dart';


class UserProfile extends StatefulWidget {
  final User user;


  UserProfile({this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ProfileHeader(user: widget.user,),
          Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Text("Stats: placeholder"),
              Text("Length: placeholder"),
            ],
          )
        ],
      ),
      appBar: AppBar(
        elevation: 0,
      ),
    );  }
}
