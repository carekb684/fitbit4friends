import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/model/is_friend.dart';
import 'package:fitbit_for_friends/model/is_friend_view_model.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {


  static Widget create(BuildContext context) {
    final fireService = Provider.of<FirestoreService>(context);
    return Provider<IsFriendViewModel>(
      create: (_) => IsFriendViewModel(fireService),
      child: FriendList(),
    );
  }

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  FirestoreService fireServ;

  final addSuccessBar = SnackBar(content: Text('Added a new friend!'));
  final removeSuccessBar = SnackBar(content: Text('Removed friend!'));
  final removeFailBar = SnackBar(content: Text('Failed to remove friend!'));

  @override
  Widget build(BuildContext context) {
    IsFriendViewModel viewModel = Provider.of<IsFriendViewModel>(context);

    return StreamBuilder<List<IsFriend>>(
      stream: viewModel.isFriendStream(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<IsFriend> friends = snapshot.data;
          if (friends == null || friends.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text("No other users available :("),
              )
            );
          } else {
            return listView(friends);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
        );
      },
    );
  }

  Color getFriendColor(IsFriend friend) {
    return friend.isFriend ? Colors.red : Colors.grey;
  }

  SnackBar addOrRemoveFriend(IsFriend friend) {
    if (friend.isFriend) {
      try {
        getFireService().removeFriend(friend.user.uid);
        return removeSuccessBar;
      } catch (e) {
        return removeFailBar;
      }
    } else {
      getFireService().addFriend(friend.user.uid);
      return addSuccessBar;
    }
  }

  FirestoreService getFireService() {
    if (fireServ == null) {
      fireServ = Provider.of<FirestoreService>(context, listen: false);
      return fireServ;
    } else {
      return fireServ;
    }
  }

  Widget listView(List<IsFriend> friends) {

    //remove logged in user
    LoggedUser loggedUser = Provider.of<LoggedUser>(context, listen: false);
    friends.removeWhere((element) => element.user.uid == loggedUser.uid);

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
            title: Text(friend.user.fullName),
            leading: Container(
              margin: EdgeInsets.only(top:2.0, bottom: 2.0),
              child: ClipOval(
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: friend.user.photoUrl + "?height=500",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add,
                color: getFriendColor(friend),
              ),
              iconSize: 30,
              onPressed: () {
                SnackBar snackBar = addOrRemoveFriend(friend);
                Scaffold.of(context).showSnackBar(snackBar);
              },
            )
        );
      },
    );

  }
}



