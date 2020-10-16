import 'package:flutter/material.dart';
import 'package:mtpLiveSound/core/services/auth_services.dart';
import 'package:mtpLiveSound/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

//Test OK
class GoogleLoginButton extends StatefulWidget {
  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    return OutlineButton(
      onPressed: () {
        _isProcessing = true;
        user.signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MyHomePage();
                },
              ),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      splashColor: Colors.grey,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
                image: AssetImage('assets/images/google_logo.png'), height: 35),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
