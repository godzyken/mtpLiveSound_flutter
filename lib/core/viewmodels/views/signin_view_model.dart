import 'package:flutter/widgets.dart';
import 'package:mtp_live_sound/core/services/auth_services.dart';
import 'package:mtp_live_sound/core/viewmodels/views/base_model.dart';

class SignInViewModel extends BaseModel {
  final Auth _authService;

  SignInViewModel({@required Auth authenticationService})
      : _authService = authenticationService;

  String errorMessage;
  String _email;
  String _password;

  Future signIn({String email, String password}) async {
    setState(true);
    var userCreate = await _authService.createUser();
    if (userCreate) {
      setState(true);
      return await _authService.createUserWithEmailAndPassword(
          email: _email, password: _password);
    } else {
      setState(false);
      return null;
    }
  }
}