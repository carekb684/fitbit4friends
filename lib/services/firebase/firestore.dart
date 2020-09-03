import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/is_friend_id_map.dart';
import 'package:fitbit_for_friends/model/profile_model.dart';
import 'package:flutter/foundation.dart';

import 'authService.dart';

class FirestoreService {

  FirestoreService({@required this.loggedUid});

  final String loggedUid;
  final firestore = FirebaseFirestore.instance;

  void addUser(LoggedUser user, String fitbitUid) {
    //TODO: if not already added?
    Map obj = <String, dynamic>{"name": user.fullName, "uid": user.uid, "photoUrl": user.photoUrl, "fitbitId": fitbitUid};
    firestore.collection("users").doc(user.uid).set(obj);
  }

  Future<QuerySnapshot> getAllUsers() {
    return firestore.collection("users").get();
  }

  Future<QuerySnapshot> getAllFriends() {
    return firestore.collection("friends").get();
  }

  Stream<List<IsFriendId>> friendsStream() {
    return firestore.collection("users").doc(loggedUid).collection("userfriends").doc(loggedUid).snapshots().map(_friendListFromSnapshot);
  }

  Stream<List<LoggedUser>> userStream() {
    return firestore.collection("users").snapshots().map(_loggedUserFromSnapshot);
  }

  List<LoggedUser> _loggedUserFromSnapshot(QuerySnapshot snap) {
    return snap.docs.map((doc){
      var data = doc.data();
      return LoggedUser(uid: data["uid"], photoUrl: data["photoUrl"], fullName: data["name"], fitbitId: data["fitbitId"]);
    }).toList();
  }

  List<IsFriendId> _friendListFromSnapshot(DocumentSnapshot snap) {
    var data = snap.data();
    List<IsFriendId> isFriends = [];
    List<dynamic> uids = data == null ? [] : data["uids"];
    for (dynamic uid in uids) {
      isFriends.add(IsFriendId(uid: uid, isFriend: true));
    }
    return isFriends;
  }

  void addFriend(String uid) {
      var ref = firestore.collection("users").doc(loggedUid).collection("userfriends").doc(loggedUid);
      ref.set({"uids": [uid]}, SetOptions(merge:true));
  }

  void removeFriend(String uid) async {
    await firestore.collection("users").doc(loggedUid).collection("userfriends").doc(loggedUid).
      update({"uids": FieldValue.arrayRemove([uid])});
  }

  void setProfileInfo(ProfileModel profile) {
    var ref = firestore.collection("users").doc(loggedUid).collection("profile").doc(loggedUid);
    ref.set({"win": profile.winText, "lose": profile.loseText, "str": profile.strText}, SetOptions(merge:true));
  }

  Future<DocumentSnapshot> getProfileData() {
    return firestore.collection("users").doc(loggedUid).collection("profile").doc(loggedUid).get();
  }

}
