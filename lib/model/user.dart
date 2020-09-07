
import 'package:fitbit_for_friends/model/is_friend.dart';
import 'package:fitbit_for_friends/services/firebase/authService.dart';

class UserWithData extends LoggedUser{
  UserWithData({this.distanceKm, String photoUrl, String uid, String name, String fitbitId}) : super(uid: uid, photoUrl: photoUrl, fullName: name, fitbitId: fitbitId);

  int distanceKm;

  static UserWithData fromFriend(IsFriend friend) {
    return UserWithData(distanceKm: null, photoUrl: friend.user.photoUrl, uid: friend.user.uid, name: friend.user.fullName, fitbitId: friend.user.fitbitId);
  }
}