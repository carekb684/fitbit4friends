import 'dart:convert';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/src/secure_storage.dart';
import 'package:oauth2_client/src/storage.dart';
import 'package:oauth2_client/src/token_storage.dart';


class FitTokenStorage extends TokenStorage {
  FitTokenStorage(String key) : super(key);

  Future<AccessTokenResponse> getToken(List<String> scopes) async {
    AccessTokenResponse tknResp;

    final serTokens = await storage.read(key);
    final scopeKey = getScopeKey(scopes);
    if (serTokens != null) {
      final Map<String, dynamic> tokens = jsonDecode(serTokens);

      if (tokens.containsKey(scopeKey)) {
        tknResp = AccessTokenResponse.fromMap(tokens[scopeKey]);
      }
    }

    return tknResp;
  }

}