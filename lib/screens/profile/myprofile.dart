import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbit_for_friends/model/profile_model.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/profileheader.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:fitbit_for_friends/services/fitbit/oauth_fitbit.dart';
import 'package:fitbit_for_friends/services/fitbit/oauth_helper_fitbit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:provider/provider.dart';

import '../mainDrawer.dart';

class MyProfile extends StatefulWidget {
  final LoggedUser user;

  MyProfile({this.user});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  _MyProfileState() {
    oauth = OAuthFitbit(customUriScheme: "fitbitforfriends", redirectUri: "fitbitforfriends://redirecturi");
    oauthHelper = OauthFitbitHelper(oauth);
  }

  OAuthFitbit oauth;
  OauthFitbitHelper oauthHelper;

  TextEditingController authController =
      new TextEditingController(text: "initial value");
  TextEditingController travelController = new TextEditingController(text: "");
  TextEditingController lostController = new TextEditingController(text: "");
  TextEditingController strController = new TextEditingController(text: "");

  bool authReadOnly = true;
  bool travelReadOnly = true;
  bool lostReadOnly = true;
  bool strengthReadOnly = true;

  ProfileModel profileModel = ProfileModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String initTravelText = "";
  String initLostText = "";
  String initStrText = "";

  String savedTravelText;
  String savedLostText;
  String savedStrText;

  FirestoreService fireServ;


  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  void dispose() {
    authController.dispose();
    strController.dispose();
    travelController.dispose();
    lostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(
                name: widget.user.fullName, photoUrl: widget.user.photoUrl),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("Register fitbit"),
                          onPressed: () => Oauth(),
                        ),
                      ]),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("Where would you go if you won?"),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          //initialValue: initTravelText,
                                          controller: travelController,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 5,
                                          onSaved: (String str) {
                                            savedTravelText = str;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("Who do you think will lose?"),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: lostController,
                                          //initialValue: initLostText,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 5,
                                          onSaved: (String str) {
                                            savedLostText = str;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("What is your greatest strength?"),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: strController,
                                          //initialValue: initStrText,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 5,
                                          onSaved: (String str) {
                                            savedStrText = str;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width: 220,
                              height: 50,
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.blue,
                                child: Text("Save"),
                                onPressed: () {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  _formKey.currentState.save();
                                  getFireService().setProfileInfo(ProfileModel(winText: savedTravelText, loseText: savedLostText, strText: savedStrText));

                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: RaisedButton(
                      textColor: Colors.blue,
                      color: Colors.white,
                      child: Text("Cancel"),
                      onPressed: () {
                        strController.clear();
                        travelController.clear();
                        lostController.clear();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: MainDrawer(),
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

  void getProfileData() {
    getFireService().getProfileData().then((value) {
      profileModel = _profileModelFromSnapshot(value);
      travelController.text = profileModel.winText;
      lostController.text = profileModel.loseText;
      strController.text = profileModel.strText;
    });
  }

  ProfileModel _profileModelFromSnapshot(DocumentSnapshot event) {
    var data = event.data();
    var profile = data == null ? ProfileModel() : ProfileModel(loseText: data["lose"], winText: data["win"], strText: data["str"]);
    return profile;
  }

  Oauth() {
    /*
    // TODO: change url here to get profile maybe?
    Future<Response> resp = oauthHelper.get("https://www.fitbit.com/oauth2/authorize");
    resp.then((value) {
      print("test");
    });
    */
  }
}
