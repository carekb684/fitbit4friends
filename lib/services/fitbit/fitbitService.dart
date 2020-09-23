
import 'package:fitbit_for_friends/model/fitbitPackage.dart';
import 'package:fitbit_for_friends/services/fitbit/oauth_helper_fitbit.dart';
import 'package:http/http.dart';

class FitbitService {

  FitbitService({this.fitBitHelper}){
    int month = DateTime.now().month;
    String monthStr = month == 9 ? "09" : "10";
    LOG_STRING_1 = "?afterDate=2020-" +monthStr+ "-01&sort=asc&limit=20&offset=0";
    LOG_STRING_2 = "?afterDate=2020-" +monthStr+ "-10&sort=asc&limit=20&offset=0";
    LOG_STRING_3 = "?afterDate=2020-" +monthStr+ "-20&sort=asc&limit=20&offset=0";
  }

  OauthFitbitHelper fitBitHelper;

  final String FITBIT_BASE_URL = "https://api.fitbit.com/1/user/";

  String LOG_STRING_1;
  String LOG_STRING_2;
  String LOG_STRING_3;

  Map<String, FitBitPackage> fakeData = {
    "QXVXD4JNJAYofXxcCqSkst78Inr1" : FitBitPackage(distanceKm: 6), //Carl
    "tz4hy70LKvbrcM3gpyuhyCMgxRx1" : FitBitPackage(distanceKm: 12), //Amir
  };

  Future<FitBitPackage> getData(String uid) {
    return Future.delayed(Duration(seconds: 5), () {
      return fakeData[uid];
    });

  }


  Future<Response> getAllDistances1(String fitBitUserId) {
   return fitBitHelper.get(FITBIT_BASE_URL + fitBitUserId + "/activities/list.json" + LOG_STRING_1);
  }

  Future<Response> getAllDistances2(String fitBitUserId) {
   return fitBitHelper.get(FITBIT_BASE_URL + fitBitUserId + "/activities/list.json" + LOG_STRING_2);
  }

  Future<Response> getAllDistances3(String fitBitUserId) {
   return fitBitHelper.get(FITBIT_BASE_URL + fitBitUserId + "/activities/list.json" + LOG_STRING_3);
  }


}