import 'package:fitbit_for_friends/services/firebase/authService.dart';

class IsFriend {
  IsFriend({this.user, this.isFriend});
  LoggedUser user;
  bool isFriend;
}