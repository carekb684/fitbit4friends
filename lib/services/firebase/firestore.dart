import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:fitbit_for_friends/model/user.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {

  FirestoreService() {
      currentUid = firebaseAuth.currentUser.uid;
  }

  final firestore = FirebaseFirestore.instance;
  fire.FirebaseAuth firebaseAuth = fire.FirebaseAuth.instance;
  String currentUid;

  Future<QuerySnapshot> getAllUsers() {
    return firestore.collection("users").get();
  }

  Future<QuerySnapshot> getAllFriends() {
    return firestore.collection("friends").get();
  }


  void addUser(User user) {
    Map obj = <String, dynamic>{"name": user.name, "uid": user.uid, "photoUrl": user.photoUrl};
    firestore.collection("users").doc(user.uid).set(obj);
  }

  String getCurrentUid() {
    return currentUid;
  }

  User fireUserConvert(fire.User fire) {
    var user = User(name: fire.displayName, uid: fire.uid, photoUrl: fire.photoUrl);
    return user;
  }

  bool addFriend(String uid) {
    if (currentUid!= null && currentUid.isNotEmpty) {
      var ref = firestore.collection("friends").doc(currentUid);
      ref.set({"uids": [uid]}, SetOptions(merge:true));
      return true;
    } else {
      return false;
    }
  }

  void removeFriend(String uid) async {
    await firestore.collection("friends").doc(currentUid).update({"uids": FieldValue.arrayRemove([uid])});
  }

}
