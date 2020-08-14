import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbit_for_friends/model/user.dart';

class FirestoreService {

  FirestoreService() {
    firebaseAuth.currentUser().then((value){
      currentUid = value.uid;
    });
  }

  final firestore = Firestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUid;

  Future<QuerySnapshot> getAllUsers() {
    return firestore.collection("users").getDocuments();
  }

  Future<QuerySnapshot> getAllFriends() {
    return firestore.collection("friends").getDocuments();
  }


  void addUser(User user) {
    Map obj = <String, dynamic>{"name": user.name, "uid": user.uid, "photoUrl": user.photoUrl};
    firestore.collection("users").document(user.uid).setData(obj);
  }

  String getCurrentUid() {
    return currentUid;
  }

  User fireUserConvert(FirebaseUser fire) {
    var user = User(name: fire.displayName, uid: fire.uid, photoUrl: fire.photoUrl);
    return user;
  }

  bool addFriend(String uid) {
    if (currentUid!= null && currentUid.isNotEmpty) {
      Map obj = <String, dynamic>{"uid": uid};
      firestore.collection("friends").document(currentUid).setData(obj);
      return true;
    } else {
      return false;
    }
  }

  void removeFriend(String uid) async {
    await firestore.collection("friends").document(uid).delete();
  }

}
