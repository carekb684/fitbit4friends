import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/model/is_friend.dart';
import 'package:fitbit_for_friends/model/is_friend_view_model.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/userprofile.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:fitbit_for_friends/services/fitbit/fitbitService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mainDrawer.dart';

class Leaderboard extends StatefulWidget {

  static Widget create(BuildContext context) {
    final fireService = Provider.of<FirestoreService>(context);
    return Provider<IsFriendViewModel>(
      create: (_) => IsFriendViewModel(fireService),
      child: Leaderboard(),
    );
  }


  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  List<IsFriend> userList = [];
  List<UserWithData> userDataList = [];
  int longestDistance = 0;
  Map<String, int> userData = Map();

  FirestoreService fireServ;
  FitbitService fitServ;

  Stream<List<IsFriend>> _friendStream;

  bool init = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    IsFriendViewModel viewModel = Provider.of<IsFriendViewModel>(context);
    fitServ = Provider.of<FitbitService>(context);
    _friendStream = viewModel.isFriendStream();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: StreamBuilder<List<IsFriend>>(
        stream: _friendStream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<IsFriend> friends = snapshot.data;
            if (friends == null || friends.isEmpty) {
              return Scaffold(
                  body: Center(
                    child: Text("Friend list is empty :("),
                  )
              );
            } else {
              if (init) {
                longestDistance = 0;
                userList = friends; //TODO: temp
                userDataList = userList.map((e) => UserWithData.fromFriend(e)).toList();
                getFitBitData();
                init = false;
              }
              return getListview(userList);
            }
          }
          return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              )
          );
        }
      ),
      appBar: AppBar(
          title: Text("Leaderboard")
      ),
      drawer: MainDrawer(),
    );
  }

  void getFitBitData() async {
    for (IsFriend friend  in userList) {
      if (friend.user.fitbitId == null || friend.user.fitbitId.isEmpty) {
        continue;
      }
      fitServ.getAllDistances(friend.user.fitbitId).then((value) {
        Map<String, dynamic> distancesMap = jsonDecode(value.body);
        //int distance = distancesMap["distance"];
        int distance = 5;
        setDistanceOnUser(distance, friend.user.uid);
        saveLongestDistance(distance);
        setState(() {
          sortUsers(userDataList);
          userData[friend.user.uid] = distance;
        });
      });

      /*
      await fitbitServ.getData(friend.user.uid).then((fitData) {
        setState(() {
          setDistanceOnUser(fitData.distanceKm, friend.user.uid);
          totalDistance += fitData.distanceKm;
          sortUsers(userDataList);
          userData[friend.user.uid] = fitData;
        });
      });
    */

    }
  }

  /** returns the distance or a progress indicator
   *
   */
  Widget getDistanceWidget(int distance) {
    if (distance == null) {
      return CircularProgressIndicator();
    }

    return Text(
      "${distance} km",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
  }

  List<UserWithData> sortUsers(List<UserWithData> users) {
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
    for (UserWithData user in userDataList) {
      if (uid == user.uid) {
        user.distanceKm = distanceKm;
        break;
      }
    }
  }

  double getDistancePercentage(int distance) {
    if(distance == null) {
      return 0.0;
    }
    if (longestDistance == 0) {
      return 1.0;
    }
    double perc = distance / longestDistance;
    return perc;
  }

  Widget getListview(List<IsFriend> friends) {
    LoggedUser loggedUser = Provider.of<LoggedUser>(context, listen: false);
    friends.removeWhere((element) => element.isFriend == false && element.user.uid != loggedUser.uid);



    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (context, index) {
        UserWithData user = userDataList[index];

        return Stack(
          children: <Widget>[
            FractionallySizedBox(
                child: Container(color:Colors.lightBlueAccent, height: 56,),
                widthFactor: getDistancePercentage(userData[user.uid])),
            ListTile(
              title: Text(user.fullName),
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
              trailing: getDistanceWidget(userData[user.uid]),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(user: user)));
              },
            ),
          ],
        );
      },
    );

  }

  FirestoreService getFireService() {
    if (fireServ == null) {
      fireServ = Provider.of<FirestoreService>(context, listen: false);
      return fireServ;
    } else {
      return fireServ;
    }
  }

  void saveLongestDistance(int distance) {
    if (distance > longestDistance) {
      longestDistance = distance;
    }
  }
}


