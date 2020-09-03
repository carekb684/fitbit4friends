import 'package:fitbit_for_friends/screens/mainDrawer.dart';
import 'package:flutter/material.dart';

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
          Center(child: Text('"Alla kämpar faller segerlösa..."'))
        ],
      ),
      appBar: AppBar(
        title: Text("Home")
      ),
      drawer: MainDrawer(),
    );



  }
}
