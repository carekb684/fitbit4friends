import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/myprofile.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;



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
  User user = User(name: "", photoUrl: "");

  @override
  void initState() {
    super.initState();
    fire.User fireUser = _auth.currentUser();
      setState(() {
        this.user = User(name: fireUser.displayName, photoUrl: fireUser.photoURL, uid: fireUser.uid);
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
                          imageUrl: user.photoUrl + "?height=500",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                      ),
                    ),
                  Text(user.name, style: TextStyle(fontSize:22, color:Colors.white))
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
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(user: user)));}
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
