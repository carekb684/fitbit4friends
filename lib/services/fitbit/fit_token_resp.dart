
import 'dart:convert';

import 'package:http/http.dart';
import 'package:oauth2_client/access_token_response.dart';

class FitAccessTokenResponse extends AccessTokenResponse {

  FitAccessTokenResponse();

  factory FitAccessTokenResponse.fromAccessTokenResponse(AccessTokenResponse atr) {
    var fatr = FitAccessTokenResponse();
    fatr.accessToken = atr.accessToken;
    return fatr;
  }

  String userId;

  factory FitAccessTokenResponse.fromHttpResponse(Response response,
      {requestedScopes}) {
    AccessTokenResponse resp;

    if (response.statusCode != 404) {
      Map respMap = jsonDecode(response.body);
      //From Section 4.2.2. (Access Token Response) of OAuth2 rfc, the "scope" parameter in the Access Token Response is
      //"OPTIONAL, if identical to the scope requested by the client; otherwise, REQUIRED."
      if ((!respMap.containsKey('scope') || respMap['scope'].isEmpty) &&
          requestedScopes != null) {
        respMap['scope'] = requestedScopes;
      }
      respMap['http_status_code'] = response.statusCode;

      resp = FitAccessTokenResponse.fromMap(respMap);
    } else {
      resp = FitAccessTokenResponse();
      resp.httpStatusCode = response.statusCode;
    }

    return resp;
  }

  FitAccessTokenResponse.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (isValid()) {
      accessToken = map['access_token'];
      tokenType = map['token_type'];
      userId = map["user_id"];
      if (map.containsKey('refresh_token')) refreshToken = map['refresh_token'];

      if (map.containsKey('scope')) {
        if (map['scope'] is List) {
          List scopesJson = map['scope'];
          scope = List.from(scopesJson);
        } else {
          //The OAuth 2 standard suggests that the scopes should be a space-separated list,
          //but some providers (i.e. GitHub) return a comma-separated list
          scope = map['scope']?.split(RegExp(r'[\s,]'));
        }

        scope = scope?.map((s) => s.trim())?.toList();
      }

      if (map.containsKey('expires_in')) {
        try {
          expiresIn = map['expires_in'] is String
              ? int.parse(map['expires_in'])
              : map['expires_in'];
        } on FormatException {
          //Provide a fallback value if the expires_in parameter is not an integer...
          expiresIn = 60;
          //...But rethrow the exception!
          rethrow;
        }
      }

      expirationDate = null;

      if (map.containsKey('expiration_date') &&
          map['expiration_date'] != null) {
        expirationDate =
            DateTime.fromMillisecondsSinceEpoch(map['expiration_date']);
      } else {
        if (expiresIn != null) {
          var now = DateTime.now();
          expirationDate = now.add(Duration(seconds: expiresIn));
        }
      }
    }
  }
}