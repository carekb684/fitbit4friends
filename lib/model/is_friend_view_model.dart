import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'is_friend.dart';
import 'is_friend_id_map.dart';

class IsFriendViewModel {

  IsFriendViewModel(@required this.firestore);

  final FirestoreService firestore;

  Stream<List<IsFriend>> isFriendStream() {
    return Rx.combineLatest2(firestore.userStream(), firestore.friendsStream(),
            (List<LoggedUser> users, List<IsFriendId> friends) {
              return users.map((user) {
                final isFriendId = friends?.firstWhere(
                        (friend) => friend.uid == user.uid,
                orElse: () => null);
                return IsFriend(user: user, isFriend: isFriendId?.isFriend ?? false); // if isFriend is null pass False
              }).toList();
    });
  }


}