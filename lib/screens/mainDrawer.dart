import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/screens/profile/myprofile.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'friends/friends.dart';
import 'home/home.dart';
import 'leaderboard/leaderboard.dart';
import 'log/manual_log.dart';

class MainDrawer extends StatefulWidget {

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  LoggedUser user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedUser user = Provider.of<LoggedUser>(context, listen: false);

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
                          imageUrl: user.photoUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                      ),
                    ),
                  Text(user.fullName, style: TextStyle(fontSize:22, color:Colors.white))
                ],)
            )
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text("Home", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));}
          ),
          /*ListTile(
              leading: Icon(Icons.event),
              title: Text("Manual log", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Log()));}
          ),*/
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(user: user)));}
          ),
          ListTile(
            leading: Icon(Icons.accessibility_new),
            title: Text("Leaderboard", style: TextStyle(fontSize: 18)),
              onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Leaderboard.create(context)));}
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
              AuthService auth = Provider.of<AuthService>(context, listen:false);
              auth.signOut();
            }
          ),
        ],)
    );
  }

}
