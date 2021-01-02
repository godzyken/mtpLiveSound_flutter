import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mtp_live_sound/core/models/user.dart' as user;

abstract class AuthBase {
  Future<auth.User> getCurrentUser();

  Future<String> checkAuth();

  Future<String> createUserWithEmailAndPassword(
      {String email, String password});

  Future<String> login({String email, String password});

  Future<String> signInWithEmailAndPassword({String email, String password});

  Future<String> createUserAnonymous();

  Future<String> signInWithGoogle();

  Future<void> signOut();

  Future<void> resetPassword();

  Future<void> verifyEmail();

  Future<void> setDisplayName();

  Future<void> checkDisplayName();
}

class Auth implements AuthBase {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  auth.User _user;

  String name;
  String email;
  String password;
  String imageUrl;
  var currentUser;

  user.User get _currentUser => currentUser;

  Future createUser({
    String displayName,
    String email,
    String password,
    String photoUrl,
    String uid,
  }) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => login(email: email, password: password));
  }

  @override
  Future<auth.User> getCurrentUser() async {
    _user = _auth.currentUser;
    return _user;
  }

  @override
  Future<String> checkAuth() async {
    await Firebase.initializeApp();

    if (_auth.currentUser != null) {
      print('Already Signed in !');
      return _currentUser.uid;
    } else {
      print('Signed Out');
      return null;
    }
  }

  @override
  Future<String> createUserAnonymous() async {
    await Firebase.initializeApp();

    try {
      auth.UserCredential userCredential = await _auth.signInAnonymously();
      _user = userCredential.user;
      return _user.uid;
    } on auth.FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      {String email, String password}) async {
    await Firebase.initializeApp();

    try {
      auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Users: $userCredential');
      _user = userCredential.user;

      return _user.uid;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        print('Error: password is to weak');
      } else if (e.code == 'email-already-in-use') {
        print('Error: the account already exist for that email');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  @override
  Future<String> login({String email, String password}) async {
    await Firebase.initializeApp();

    try {
      final auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      final _user = userCredential.user;
      if (_user != null) {
        assert(_user.email != null);
        assert(_user.displayName != null);

        // Store the retrieved data
        name = _user.displayName;
        email = _user.email;

        // Only taking the first part of the name, i.e., First Name
        if (name.contains(" ")) {
          name = name.substring(0, name.indexOf(" "));
        }

        assert(!_user.isAnonymous);
        assert(await _user.getIdToken() != null);

        final auth.User currentUser = _auth.currentUser;
        assert(_user.uid == currentUser.uid);

        return 'signInSuccess: $_user';
      }
    } on auth.FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
    return login != null ?? 'Login in Success';
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    await Firebase.initializeApp();

    try {
      auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      print('Users: $userCredential');

      _user = userCredential.user;
      return _user.uid;
    } on auth.FirebaseAuthException catch (e) {
      print('Error: $e');
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final _user = authResult.user;

      if (_user != null) {
        assert(_user.email != null);
        assert(_user.displayName != null);
        assert(_user.photoURL != null);

        // Store the retrieved data
        name = _user.displayName;
        email = _user.email;
        imageUrl = _user.photoURL;

        // Only taking the first part of the name, i.e., First Name
        if (name.contains(" ")) {
          name = name.substring(0, name.indexOf(" "));
        }

        assert(!_user.isAnonymous);
        assert(await _user.getIdToken() != null);

        final auth.User currentUser = _auth.currentUser;
        assert(_user.uid == currentUser.uid);

        return 'signInSuccess: $_user';
      }
    } on PlatformException catch (e) {
      print(e.code);
      return null;
    }

    return GoogleSignIn != null ?? 'Google Sign in Success';
  }

  //TODO voir pourquoi noSuchMethodError was thrown while handling a gesture
  //the method 'signOut' was xa
  @override
  signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();

    print("User Signed Out: $_user");
  }

  @override
  Future<void> checkDisplayName() async {
    await Firebase.initializeApp();

    _user = _auth.currentUser;
    print(_user.displayName);
  }

  @override
  Future<void> setDisplayName() async {
    await Firebase.initializeApp();

    _user = _auth.currentUser;
    _user.updateProfile(displayName: name);
  }

  @override
  Future<void> verifyEmail() async {
    await Firebase.initializeApp();

    _user = _auth.currentUser;
    _user.sendEmailVerification();
  }

  @override
  Future<void> resetPassword() async {
    await Firebase.initializeApp();

    await _auth.sendPasswordResetEmail(email: email);
  }
}

final Auth authService = Auth();
