import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import 'fit_token_resp.dart';

class OauthFitbitHelper extends OAuth2Helper {

  OauthFitbitHelper(OAuth2Client client) : super(client,
  grantType: OAuth2Helper.AUTHORIZATION_CODE,
  clientId: '22BRLL',
  clientSecret: '57aaac198da466f163535055ec4e6472',
  scopes: ['activity', 'profile', 'social'],
  );

  Future<FitAccessTokenResponse> getToken() async {
    //_validateAuthorizationParams();

    var tknResp = await getTokenFromStorage();
    //var tknResp = null; do this to reset token...
    if (tknResp != null) {
      if (tknResp.refreshNeeded()) {
        //The access token is expired
        tknResp = await refreshToken(tknResp.refreshToken);
      }
      FitAccessTokenResponse tkn = FitAccessTokenResponse.fromAccessTokenResponse(tknResp);
      return tkn;
    } else {
      tknResp = await fetchToken();
    }

    if (tknResp != null && !tknResp.isBearer()) {
      throw Exception('Only Bearer tokens are currently supported');
    }

    return tknResp;
  }

  Future<FitAccessTokenResponse> fetchToken() async {
    //_validateAuthorizationParams();

    FitAccessTokenResponse tknResp;

    if (grantType == OAuth2Helper.AUTHORIZATION_CODE) {
      tknResp = await client.getTokenWithAuthCodeFlow(
          clientId: clientId,
          clientSecret: clientSecret,
          scopes: scopes,
          authCodeParams: authCodeParams,
          accessTokenParams: accessTokenParams,
          afterAuthorizationCodeCb: afterAuthorizationCodeCb);
    } else if (grantType == OAuth2Helper.CLIENT_CREDENTIALS) {
      tknResp = await client.getTokenWithClientCredentialsFlow(
          clientId: clientId, clientSecret: clientSecret, scopes: scopes);
    }

    if (tknResp != null && tknResp.isValid()) {
      await tokenStorage.addToken(tknResp);
    }

    return tknResp;
  }


}