import 'package:fitbit_for_friends/screens/mainDrawer.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child:
              Center(
                child: Text("Welcome to",
                style: TextStyle(fontSize: 40),),
              )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text("The October bet!",
                    style: TextStyle(fontSize: 45),),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Center(child: Text('"Alla kämpar faller segerlösa..."')),
          SizedBox(height: 40),
          SizedBox(
            width: 220,
            height: 50,
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("Sign out"),
              onPressed: () {

                AuthService auth = Provider.of<AuthService>(context, listen:false);
                auth.signOut();
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Home")
      ),
      drawer: MainDrawer(),
    );



  }

}
