import 'package:flutter/widgets.dart';
import 'package:mtpLiveSound/core/services/auth_services.dart';
import 'package:mtpLiveSound/core/services/dialog_service.dart';
import 'package:mtpLiveSound/core/services/navigation_service.dart';
import 'package:mtpLiveSound/core/viewmodels/views/base_model.dart';


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

  get email => _email;

  get password => _password;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  Future login({String email, String password}) async {
    setState(true);
    var result = await _authenticationService.login(
      email: _email,
      password: _password,
    );

    if (result is bool) {
      if (result != null) {
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
        description: result,
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

  Future ghostMode() async {
    setState(true);

    var success = await _authenticationService.createUserAnonymous();
    if (success != null) {
      setState(true);
      print('Success to connect the ghost Mode... $success');
      return success;
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
