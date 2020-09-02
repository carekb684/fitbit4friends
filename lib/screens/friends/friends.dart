import 'package:fitbit_for_friends/screens/friends/friend_list.dart';
import 'package:flutter/material.dart';

import '../mainDrawer.dart';

class FindFriends extends StatefulWidget {

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {

  @override
  void initState() {
    super.initState();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: FriendList.create(context),
        appBar: AppBar(
            title: Text("Find friends")
        ),
        drawer: MainDrawer(),
      );
    }



}
