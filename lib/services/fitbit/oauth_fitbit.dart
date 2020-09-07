import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/authorization_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/src/oauth2_utils.dart';
import 'package:random_string/random_string.dart';

import 'fit_auth_resp.dart';
import 'fit_token_resp.dart';

class OAuthFitbit extends OAuth2Client {
  OAuthFitbit({@required String redirectUri, @required String customUriScheme})
      : super(
          authorizeUrl: 'https://www.fitbit.com/oauth2/authorize',
          //Your service's authorization url
          tokenUrl: 'https://api.fitbit.com/oauth2/token',
          //Your service access token url
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );

  @override
  Future<AuthorizationResponse> requestAuthorization({
    @required String clientId,
    List<String> scopes,
    String codeChallenge,
    String state,
    Map<String, dynamic> customParams,
    webAuthClient,
  }) async {
    webAuthClient ??= this.webAuthClient;

    //state ??= randomAlphaNumeric(25);

    final authorizeUrl = getAuthorizeUrl(
        clientId: clientId,
        redirectUri: redirectUri,
        scopes: scopes,
        state: state,
        codeChallenge: codeChallenge,
        customParams: customParams);

    // Present the dialog to the user
    final result = await webAuthClient.authenticate(
        url: authorizeUrl, callbackUrlScheme: customUriScheme);

    return FitAuthorizationResponse.fromRedirectUri(result, state);
  }

  @override
  Future<FitAccessTokenResponse> requestAccessToken(
      {@required String code,
        @required String clientId,
        String clientSecret,
        String codeVerifier,
        List<String> scopes,
        Map<String, dynamic> customParams,
        httpClient}) async {
    httpClient ??= Client();

    final body = getTokenUrlParams(
        code: code,
        redirectUri: redirectUri,
        clientId: clientId,
        clientSecret: clientSecret,
        codeVerifier: codeVerifier,
        customParams: customParams);

    String credentials = clientId + ":" + clientSecret;
    String encoded = base64.encode(utf8.encode(credentials));

    var response = await httpClient.post(tokenUrl,
        body: body, headers: <String, String>{HttpHeaders.authorizationHeader: "Basic " + encoded, HttpHeaders.contentTypeHeader : "application/x-www-form-urlencoded"});
    return FitAccessTokenResponse.fromHttpResponse(response,
        requestedScopes: scopes);
  }

  @override
  Future<AccessTokenResponse> refreshToken(String refreshToken,
      {httpClient, String clientId, String clientSecret}) async {
    httpClient ??= Client();

    final Map body = getRefreshUrlParams(
        refreshToken: refreshToken,
        clientId: "",
        clientSecret: "");

    String credentials = clientId + ":" + clientSecret;
    String encoded = base64.encode(utf8.encode(credentials));

    Response response =
    await httpClient.post(tokenUrl, headers: <String, String>{HttpHeaders.authorizationHeader: "Basic " + encoded, HttpHeaders.contentTypeHeader : "application/x-www-form-urlencoded"} ,
        body: body);

    return AccessTokenResponse.fromHttpResponse(response);
  }

  @override
  Future<AccessTokenResponse> getTokenWithAuthCodeFlow({
    @required String clientId,
    List<String> scopes,
    String clientSecret,
    bool enablePKCE = false,
    String state,
    String codeVerifier,
    Function afterAuthorizationCodeCb,
    Map<String, dynamic> authCodeParams,
    Map<String, dynamic> accessTokenParams,
    httpClient,
    webAuthClient,
  }) async {
    FitAccessTokenResponse tknResp;

    String codeChallenge;

    if (enablePKCE) {
      codeVerifier ??= randomAlphaNumeric(80);

      codeChallenge = OAuth2Utils.generateCodeChallenge(codeVerifier);
    }

    var authResp = await requestAuthorization(
        webAuthClient: webAuthClient,
        clientId: clientId,
        scopes: scopes,
        codeChallenge: codeChallenge,
        state: state,
        customParams: authCodeParams);

    if (authResp.isAccessGranted()) {
      if (afterAuthorizationCodeCb != null) afterAuthorizationCodeCb(authResp);

      tknResp = await requestAccessToken(
          httpClient: httpClient,
          code: authResp.code,
          clientId: clientId,
          scopes: scopes,
          clientSecret: clientSecret,
          codeVerifier: codeVerifier,
          customParams: accessTokenParams);
    }

    return tknResp;
  }
}
