
import 'package:fitbit_for_friends/model/fitbitPackage.dart';
import 'package:fitbit_for_friends/services/fitbit/oauth_helper_fitbit.dart';
import 'package:http/http.dart';

class FitbitService {

  FitbitService({this.fitBitHelper});

  OauthFitbitHelper fitBitHelper;

  final String FITBIT_BASE_URL = "https://api.fitbit.com/1/user/";
  final String DISTANCE_RESOURCE_PATH = "/activities/distance";

  final String START_DATE = "2020-09-01"; //TODO: change this

  Map<String, FitBitPackage> fakeData = {
    "QXVXD4JNJAYofXxcCqSkst78Inr1" : FitBitPackage(distanceKm: 6), //Carl
    "tz4hy70LKvbrcM3gpyuhyCMgxRx1" : FitBitPackage(distanceKm: 12), //Amir
  };

  Future<FitBitPackage> getData(String uid) {
    return Future.delayed(Duration(seconds: 3), () {
      return fakeData[uid];
    });

  }


  Future<Response> getAllDistances(String fitBitUserId) {
   return fitBitHelper.get(FITBIT_BASE_URL + fitBitUserId + DISTANCE_RESOURCE_PATH + "/date/" + START_DATE + "/today.json");

  }


}