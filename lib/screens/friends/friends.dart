import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import '../mainDrawer.dart';

class FindFriends extends StatefulWidget {

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {

  List<User> usersList = [];
  List<dynamic> friendList = <dynamic>[];

  final addSuccessBar = SnackBar(content: Text('Added a new friend!'));
  final addFailBar = SnackBar(content: Text('Failed to add a new friend!'));
  final removeSuccessBar = SnackBar(content: Text('Removed friend!'));
  final removeFailBar = SnackBar(content: Text('Failed to remove friend!'));

  final FirestoreService fireServ = FirestoreService();

  SnackBar addOrRemoveFriend(String uid, BuildContext context) {
    if (friendList.contains(uid)) {
      try {
        fireServ.removeFriend(uid);
        friendList.remove(uid);
        return removeSuccessBar;
      } catch (e) {
        return removeFailBar;
      }
    } else {
      var success = fireServ.addFriend(uid);
      if (success) {
        friendList.add(uid);
        return addSuccessBar;
      } else {
        return addFailBar;
      }
    }
  }

  Color getFriendColor(String uid) {
    return friendList.contains(uid) ? Colors.red : Colors.grey;
  }

  @override
  void initState() {
    super.initState();
    _populateUsers();
  }

  void _populateUsers() async{
    var allUsers =  fireServ.getAllUsers();
    await allUsers.then((docs) {
      List<User> users = [];
      for (DocumentSnapshot doc in docs.docs) {
        var data = doc.data();
        if (data["uid"] == fireServ.getCurrentUid()) {
          continue;
        }
        User user = User(
            name: data["name"], uid: data["uid"], photoUrl: data["photoUrl"]);
        users.add(user);
      }
      setState(() {
        usersList = users;
      });
    });

    var allFriends =  fireServ.getAllFriends();
    await allFriends.then((docs) {
      List<dynamic> users = [];
      for (DocumentSnapshot doc in docs.docs) {
        if(doc.id == fireServ.getCurrentUid()) {
          users = doc.data()["uids"];
          break;
        }
      }
      setState(() {
        friendList = users != null ? users : friendList;
      });
    });
  }


    @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            final user = usersList[index];
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
              trailing: IconButton(
                icon: Icon(Icons.add,
                  color: getFriendColor(user.uid),
                ),
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    SnackBar snackBar = addOrRemoveFriend(user.uid, context);
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                },
              )
            );
          },
        ),
        appBar: AppBar(
            title: Text("Find friends")
        ),
        drawer: MainDrawer(),
      );
    }

}
