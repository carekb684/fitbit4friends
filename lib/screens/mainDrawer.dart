import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/screens/authenticationWrapper.dart';
import 'package:fitbit_for_friends/screens/profile/profile.dart';
import 'file:///C:/Users/calle/AndroidStudioProjects/fitbit_for_friends/lib/services/firebase/authService.dart';
import 'package:flutter/material.dart';

import 'friends/friends.dart';
import 'home/home.dart';
import 'leaderboard/leaderboard.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final _auth = AuthService();

  String photoUrl = "";
  String userName = "";

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) {
      setState(() {
        photoUrl = user.photoUrl;
        userName = user.displayName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width:100,
                      height: 100,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: photoUrl + "?height=500",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                      ),
                    ),
                  Text(userName, style: TextStyle(fontSize:22, color:Colors.white))
                ],)
            )
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text("Home", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));}
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Profile()));}
          ),
          ListTile(
            leading: Icon(Icons.accessibility_new),
            title: Text("Leaderboard", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Leaderboard()));}
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Find friends", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FindFriends()));}
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sign out", style: TextStyle(fontSize: 18)),
              onTap: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, "/auth");
            }
          ),
        ],)
    );
  }
}
