import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mtp_live_sound/core/services/auth_services.dart';
import 'package:mtp_live_sound/core/services/dialog_service.dart';
import 'package:mtp_live_sound/core/services/navigation_service.dart';
import 'package:mtp_live_sound/core/viewmodels/views/base_model.dart';


class LoginViewModel extends BaseModel {
  final Auth _authenticationService;
  DialogService _dialogService;
  NavigationService _navigationService;

  LoginViewModel({
    @required Auth authenticationService,
  }) : _authenticationService = authenticationService;

  String errorMessage;
  String _email;
  String _password;
  String _success;

  get email => _email;

  get password => _password;

  get success => _success;

  set success(String success) {
    _success = success;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  login({String email, String password}) async {
    setState(true);
    _success = await _authenticationService.login(
      email: _email,
      password: _password,
    );

    if (_success is bool) {
      if (_success != null) {
        setState(true);
        _navigationService.navigateTo('home');
      } else {
        setState(false);
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: _success,
      );
      setState(false);
    }
  }

  Future createUserWithCredential(String email, String password) async {
    setState(true);

    // Not null
    if (email == null) {
      errorMessage = 'Email field must be non empty!';
      setState(false);
      return false;
    }

    var success = await _authenticationService.createUser();

    // Handle potential error here too.

    setState(false);
    return success;
  }

  ghostMode() async {
    setState(true);

    _success = await _authenticationService.createUserAnonymous();
    if (_success != null) {
      setState(true);
      print('Success to connect the ghost Mode... $success');
      return _success;
    } else {
      setState(false);
      print('Error to connect $success');
      return null;
    }
  }

  Future signInWithGoogle() async {
    setState(true);

    var success = await _authenticationService.signInWithGoogle();

    if (success is bool) {
      if (success != null) {
        setState(true);
        _navigationService.navigateTo('home');
      } else {
        setState(false);
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: success,
      );
      setState(false);
    }
  }
}
