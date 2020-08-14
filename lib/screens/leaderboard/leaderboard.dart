import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/fitbitPackage.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:fitbit_for_friends/services/fitbit/fitbitService.dart';
import 'package:flutter/material.dart';

import '../mainDrawer.dart';

class Leaderboard extends StatefulWidget {

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  List<String> friendList = [];
  List<User> usersList = [];

  Map<String, FitBitPackage> userData = Map();

  final FirestoreService fireServ = FirestoreService();
  final FitbitService fitbitServ = FitbitService();

  @override
  void initState() {
    super.initState();
    _populateFriends();
  }

  void _populateFriends() async {
    var allFriends = fireServ.getAllFriends();
    await allFriends.then((docs) {
      List<String> friends = [];
      for (DocumentSnapshot doc in docs.documents) {
        String uid = doc.data["uid"];
        if(doc.documentID == fireServ.getCurrentUid()) {
          friends.add(uid);
        }
      }
      setState(() {
        friendList = friends;
        friendList.add(fireServ.getCurrentUid());
      });
    });

    var allUsers = fireServ.getAllUsers();
    await allUsers.then((docs) {
      List<User> users = [];
      for (DocumentSnapshot doc in docs.documents) {
        var data = doc.data;
        if (friendList.contains(data["uid"])) {
          User user = User(
              name: data["name"], uid: data["uid"], photoUrl: data["photoUrl"]);
          users.add(user);
        }
      }
      setState(() {
        usersList = users;
      });
    });

    await getFitBitData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          User user = usersList[index];

          return ListTile(
              title: Text(user.name),
              leading: Container(
                margin: EdgeInsets.only(top:2.0, bottom: 2.0),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: user.photoUrl + "?height=500",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              trailing: Text(
                "${userData[user.uid].distanceKm} km",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          );
        },
      ),
      appBar: AppBar(
          title: Text("Leaderboard")
      ),
      drawer: MainDrawer(),
    );
  }

  void getFitBitData() async {
    for (String uid in friendList) {
      await fitbitServ.getData(uid).then((fitData) {
        setState(() {
          userData[uid] = fitData;
        });
      });
    }
  }

}

