import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/models/post.dart';
import 'package:mtp_live_sound/core/models/user.dart';
import 'package:mtp_live_sound/core/services/api.dart';
import 'package:mtp_live_sound/core/services/auth_services.dart';
import 'package:mtp_live_sound/core/viewmodels/views/base_model.dart';

class HomeModel extends BaseModel {
  final Auth _authService;
  final Api _api;

  HomeModel({
    @required Auth authService,
    @required Api api,
  })  : _authService = authService,
        _api = api;

  List<User> users;

  Future<User> getUserById(String id) async {
    var doc = await _authService.currentUser(id);
    return User.fromJson(doc.data().id);
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  List<Post> posts;

  Future<Post> getPostById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Post.fromMap(doc.data(), doc.id);
  }

  signOut() async {
    return await _authService.signOut();
  }
}
