import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mtpLiveSound/core/models/user.dart' as user;

import 'api.dart';

abstract class AuthBase {
  Future<auth.User> getCurrentUser();

  Future<String> checkAuth();

  Future<String> createUserWithEmailAndPassword(
      {String email, String password});

  Future<String> login({String email, String password});

  Future<String> signInWithEmailAndPassword({String email, String password});

  Future<void> createUserAnonymous();

  Future<String> signInWithGoogle();

  Future<void> signOut();

  Future<void> resetPassword();

  Future<void> verifyEmail();

  Future<void> setDisplayName();

  Future<void> checkDisplayName();
}

class AuthService implements AuthBase {
  final Api _api;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthService({Api api}) : _api = api;

  String name;
  String email;
  String password;
  String imageUrl;
  var currentUser;

  user.User get _currentUser => currentUser;

  user.User _userFromFirebase(auth.User user) {
    return user == null ? null : currentUser(uid: user.uid);
  }

  Stream<user.User> get onAuthStateChanged {
    _api.streamDataCollection().listen((event) {
      onAuthStateChanged.forEach((element) {
        _currentUser;
      });
    });
    return auth.FirebaseAuth.instance
        .authStateChanges()
        .map((event) => _userFromFirebase(event));
  }

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
    auth.User user = _auth.currentUser;
    return user;
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
      print('Users: $userCredential');
      auth.User user = userCredential.user;
      return user.isAnonymous.toString();
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
      auth.User user = userCredential.user;

      return user.uid;
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
      var userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User user = userCredential.user;
      return user.uid;
    } on auth.FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    await Firebase.initializeApp();

    try {
      auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      print('Users: $userCredential');

      auth.User user = userCredential.user;
      return user.uid;
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
      final auth.User user = authResult.user;

      if (user != null) {
        assert(user.email != null);
        assert(user.displayName != null);
        assert(user.photoURL != null);

        // Store the retrieved data
        name = user.displayName;
        email = user.email;
        imageUrl = user.photoURL;

        // Only taking the first part of the name, i.e., First Name
        if (name.contains(" ")) {
          name = name.substring(0, name.indexOf(" "));
        }

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final auth.User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        return 'signInSuccess: $user';
      }
    } on PlatformException catch (e) {
      print(e.code);
      return null;
    }

    return GoogleSignIn != null ?? 'Google Sign in Success';
  }

  @override
  Future<void> signOut() async {
    await Firebase.initializeApp();
    try {
      await auth.FirebaseAuth.instance.signOut();
      print("success signOut =====>");
    } catch (e) {
      print(e.toString());
    }
    await _auth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Future<void> checkDisplayName() async {
    await Firebase.initializeApp();

    auth.User user = auth.FirebaseAuth.instance.currentUser;
    print(user.displayName);
  }

  @override
  Future<void> setDisplayName() async {
    await Firebase.initializeApp();

    auth.User user = auth.FirebaseAuth.instance.currentUser;
    user.updateProfile(displayName: name);
  }

  @override
  Future<void> verifyEmail() async {
    await Firebase.initializeApp();

    auth.User user = auth.FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<void> resetPassword() async {
    await Firebase.initializeApp();

    await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

