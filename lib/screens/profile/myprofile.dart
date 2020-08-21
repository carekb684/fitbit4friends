import 'package:fitbit_for_friends/model/user.dart';
import 'package:fitbit_for_friends/screens/profile/profileheader.dart';
import 'package:flutter/material.dart';

import '../mainDrawer.dart';


class MyProfile extends StatefulWidget {
  final User user;


  MyProfile({this.user});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  FocusNode myFocusNode;
  TextEditingController controller = new TextEditingController(text: "initial value");
  bool readOnlyKey = true;


  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ProfileHeader(user: widget.user,),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Column(
                      children: <Widget>[
                          Text("FitBit Auth key:"),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                controller: controller,
                                readOnly: readOnlyKey,
                                focusNode: myFocusNode,
                                decoration: InputDecoration(
                                  hintText: "alsij0934j02oaAJWNLjff2"
                                ),
                                onSubmitted: (String str){
                                  setState(() {
                                    readOnlyKey = true;
                                  });
                                  },
                              ),
                            ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              readOnlyKey = false;
                              myFocusNode.requestFocus();
                            });
                          },
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              SizedBox(height: 60,),
              Text("Stats: placeholder"),
              Text("Length: placeholder"),
            ],
          )
        ],
      ),
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: MainDrawer(),
    );  }
}
