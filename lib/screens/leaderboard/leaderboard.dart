import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/fitbitPackage.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/userprofile.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:fitbit_for_friends/services/fitbit/fitbitService.dart';
import 'package:flutter/material.dart';

import '../mainDrawer.dart';

class Leaderboard extends StatefulWidget {

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  List<dynamic> friendList = [];
  List<User> usersList = [];

  int totalDistance = 0;

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
      List<dynamic> friends = [];
      for (DocumentSnapshot doc in docs.docs) {
        if(doc.id == fireServ.getCurrentUid()) {
          friends = doc.data()["uids"];
          break;
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
      for (DocumentSnapshot doc in docs.docs) {
        var data = doc.data();
        if (friendList.contains(data["uid"])) {
          User user = User(
              name: data["name"], uid: data["uid"], photoUrl: data["photoUrl"]);
          users.add(user);
        }
      }
      setState(() {
        totalDistance = 0;
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

          return Stack(
            children: <Widget>[
              FractionallySizedBox(
                child: Container(color:Colors.lightBlueAccent, height: 56,),
                   widthFactor: getDistancePercentage(userData[user.uid])),
              ListTile(
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
                trailing: getDistanceWidget(userData, user),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(user: user)));
                },
              ),
            ],
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
          setDistanceOnUser(fitData.distanceKm, uid);
          totalDistance += fitData.distanceKm;
          sortUsers(usersList);
          userData[uid] = fitData;
        });
      });
    }
  }

  /** returns the distance or a progress indicator
   *
   */
  Widget getDistanceWidget(Map<String, FitBitPackage> userData, User user) {
    var data = userData[user.uid];
    if (data == null) {
      return CircularProgressIndicator();
    }

    return Text(
      "${userData[user.uid].distanceKm} km",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
  }

  List<User> sortUsers(List<User> users) {
    users.sort((a, b) {
      if (b.distanceKm == null) {
        return -1;
      }
      if (a.distanceKm == null) {
        return 1;
      }

      return b.distanceKm.compareTo(a.distanceKm);
    });
    return users;
  }

  void setDistanceOnUser(int distanceKm, String uid) {
    for (User user in usersList) {
      if (uid == user.uid) {
        user.distanceKm = distanceKm;
      }
    }
  }

  double getDistancePercentage(FitBitPackage data) {
    if(data == null || data.distanceKm == null) {
      return 0.0;
    }
    double perc = data.distanceKm / totalDistance;
    return perc;
  }

}

