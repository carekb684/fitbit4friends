import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbit_for_friends/screens/authenticate/authenticate.dart';
import 'package:fitbit_for_friends/screens/authenticationWrapper.dart';
import 'package:fitbit_for_friends/screens/friends/friends.dart';
import 'package:fitbit_for_friends/screens/home/home.dart';
import 'package:fitbit_for_friends/screens/leaderboard/leaderboard.dart';
import 'package:fitbit_for_friends/screens/profile/profile.dart';
import 'file:///C:/Users/calle/AndroidStudioProjects/fitbit_for_friends/lib/services/firebase/authService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/auth",
        routes: {
          "/profile": (context) => Profile(),
          "/leaderboard": (context) => Leaderboard(),
          "/findfriends": (context) => FindFriends(),
          "/auth": (context) => Authenticate(),
          "/home": (context) => Home(),
        }
      );
  }
}

