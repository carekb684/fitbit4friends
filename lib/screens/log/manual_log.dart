import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:fitbit_for_friends/services/firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mainDrawer.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController swimInputController = TextEditingController();
  String inputSwim;

  FirestoreService fireServ;
  Future<DocumentSnapshot> swims;

  DateTime dateTime = DateTime.now();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fireServ = Provider.of<FirestoreService>(context);
    swims = fireServ.getSwimDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),

              Text(format(dateTime), style: TextStyle(fontSize: 45),),

              SizedBox(height: 20,),


                SizedBox(
                  width: 220,
                  height: 50,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Select date"),
                    onPressed: () {
                      showDatePicker(context: context, initialDate: dateTime, firstDate: DateTime.parse("2020-09-01"), lastDate: DateTime.parse("2020-09-30"))
                          .then((value) {

                            if(value != null){
                              setState(() {
                                dateTime = value;
                              });
                            }
                      });
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                ),

              SizedBox(height: 40,),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: swimInputController,
                  decoration: InputDecoration(
                    hintText: "Add your swim distance here..",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a number";
                    } else if (!isNumeric(value)) {
                      return "Please only enter numbers";
                    }
                    return null;
                  },
                  onSaved: (String str) {
                    inputSwim = str;
                  },
                ),
              ),

              SizedBox(height: 10,),

              SizedBox(
                width: 180,
                height: 50,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text("Save swim"),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    _formKey.currentState.save();
                    swimInputController.clear();
                    fireServ.setSwimDate(format(dateTime), inputSwim);
                    setState(() {
                      swims = fireServ.getSwimDates();
                    });
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
              ),
          SizedBox(height: 20,),

          FutureBuilder<DocumentSnapshot>(
            future: swims,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                var data = snapshot.data.data();
                if (data == null || !data.containsKey(format(dateTime))) {
                  return getSnail();
                } else {
                  return Center(child: Text(data[format(dateTime)] + " units swam", style: TextStyle(fontSize: 25),));
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),

            ],
          ),
        ),
      ),
      appBar: AppBar(
          title: Text("Manual log")
      ),
      drawer: MainDrawer(),
    );
  }

  String format(DateTime dateTime) {
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
  }

  Widget getSnail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: AssetImage('assets/images/snail.PNG'),
            fit: BoxFit.cover
        ),
      ),
      child: Center(child: Text("No swims this date...", style: TextStyle(color: Colors.white, fontSize: 20),)),
    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
