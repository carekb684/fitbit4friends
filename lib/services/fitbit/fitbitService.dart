
import 'package:fitbit_for_friends/model/fitbitPackage.dart';

class FitbitService {

  Map<String, FitBitPackage> fakeData = {
    "QXVXD4JNJAYofXxcCqSkst78Inr1" : FitBitPackage(distanceKm: 52), //Carl
    "tz4hy70LKvbrcM3gpyuhyCMgxRx1" : FitBitPackage(distanceKm: 12), //Amir
  };

  Future<FitBitPackage> getData(String uid) {
    return Future.delayed(Duration(seconds: 1), () {
      return fakeData[uid];
    });

  }


}