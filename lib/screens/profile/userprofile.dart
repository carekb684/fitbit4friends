import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/profile_model.dart';
import 'package:fitbit_for_friends/screens/profile/profileheader.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserProfile extends StatefulWidget {
  final LoggedUser user;


  UserProfile({this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  FirestoreService fireServ;
  ProfileModel profileModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fireServ = Provider.of<FirestoreService>(context, listen: false);
      getProfileData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ProfileHeader(name: widget.user.fullName, photoUrl: widget.user.photoUrl),
          Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                      Text("Where would you go if you won?", style: TextStyle(fontSize: 20, color: Colors.grey[600])), SizedBox(height: 8,),
                        profileModel == null || profileModel.winText == null ? CircularProgressIndicator() : Text(profileModel.winText),
                    ],
              ),
            ],
          ),
        ],
      ),
          Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Where do you want your snail?", style: TextStyle(fontSize: 20, color: Colors.grey[600])), SizedBox(height: 8,),
                      profileModel == null || profileModel.loseText == null ? CircularProgressIndicator() : Text(profileModel.loseText),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("What is your greatest strength?", style: TextStyle(fontSize: 20, color: Colors.grey[600])), SizedBox(height: 8,),
                      profileModel == null || profileModel.strText == null ? CircularProgressIndicator() : Text(profileModel.strText),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ],
    ),
      appBar: AppBar(
        elevation: 0,
      ),
    );
  }




  void getProfileData() {
    if (fireServ != null) {
      fireServ.getProfileData(widget.user.uid).then((value) {
        setState(() {
          profileModel = profileModelFromSnapshot(value);
        });
      });
    }
  }

  ProfileModel profileModelFromSnapshot(DocumentSnapshot event) {
    var data = event.data();
    var profile = data == null ? ProfileModel() : ProfileModel(loseText: data["lose"], winText: data["win"], strText: data["str"]);
    return profile;
  }
}
