import 'package:oauth2_client/authorization_response.dart';

class FitAuthorizationResponse extends AuthorizationResponse {



  FitAuthorizationResponse.fromRedirectUri(String redirectUri, String checkState) {
    queryParams = Uri.parse(redirectUri).queryParameters;

    error = getQueryParam('error');
    errorDescription = getQueryParam('error_description');

    if (error == null) {
      code = getQueryParam('code');
      if (code == null) {
        throw Exception('Expected "code" parameter not found in response');
      }

      /*
      state = getQueryParam('state');
      if (state == null) {
        throw Exception('Expected "state" parameter not found in response');
      }

      if (state != checkState) {
        throw Exception(
            '"state" parameter in response doesn\'t correspond to the expected value');
      }

       */
    }
  }
}