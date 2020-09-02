import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbit_for_friends/model/user.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({@required this.name, this.photoUrl});

  String name;
  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Column(
              children: <Widget>[
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width:150,
                    height: 150,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: photoUrl + "?height=500",
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(name, style: TextStyle(fontSize:22, color:Colors.white)),
                )
              ],)
        )
    );
  }
}
