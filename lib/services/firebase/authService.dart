import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class LoggedUser {
  const LoggedUser({@required this.uid, this.photoUrl, this.fullName});
  final String uid;
  final String photoUrl;
  final String fullName;
}

class AuthService {
  fire.FirebaseAuth firebaseAuth = fire.FirebaseAuth.instance;

  String your_client_id = "792631628209819";
  String your_redirect_url =
      "https://www.facebook.com/connect/login_success.html";


  Future<LoggedUser> loginWithFacebook(BuildContext context, {bool clearCache}) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
                clearCache: clearCache,
          ),
          maintainState: true),
    );

    if (result != null) {
      try {
        final facebookAuthCred =
            fire.FacebookAuthProvider.credential(result);
        final user = await firebaseAuth.signInWithCredential(facebookAuthCred);

        return _userFromFirebase(user.user);
      } catch (e) {
        return null;
      }
    }
    return null;

  }

  LoggedUser _userFromFirebase(fire.User user) {
    return user == null ? null : LoggedUser(uid: user.uid, photoUrl: user.photoURL, fullName: user.displayName);
  }

  Stream<LoggedUser> get onAuthStateChanged {
    return firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  void signOut() async{
    await firebaseAuth.signOut();
  }

}

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl, this.clearCache});
  bool clearCache;

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ),
        clearCache: widget.clearCache,
        clearCookies: widget.clearCache,
    );
  }
}
