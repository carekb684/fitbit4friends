import 'package:firebase_core/firebase_core.dart';
import 'package:fitbit_for_friends/screens/authenticate/authenticate.dart';
import 'package:fitbit_for_friends/screens/friends/friends.dart';
import 'package:fitbit_for_friends/screens/home/home.dart';
import 'package:fitbit_for_friends/screens/leaderboard/leaderboard.dart';
import 'package:fitbit_for_friends/screens/profile/myprofile.dart';
import 'package:flutter/material.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/auth",
        routes: {
          "/profile": (context) => MyProfile(),
          "/leaderboard": (context) => Leaderboard(),
          "/findfriends": (context) => FindFriends(),
          "/auth": (context) => Authenticate(),
          "/home": (context) => Home(),
        }
      );
  }
}

