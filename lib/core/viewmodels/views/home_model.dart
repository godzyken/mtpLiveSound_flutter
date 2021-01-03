import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/models/models.dart';
import 'package:mtp_live_sound/core/services/services.dart';
import 'package:mtp_live_sound/core/viewmodels/views/base_model.dart';

class HomeModel extends BaseModel {
  final Auth _authService;
  final Api _api;

  HomeModel({
    @required Auth authService,
    @required Api api,
  })  : _authService = authService,
        _api = api;

  List<UserModel> users;

  Future<UserModel> getUserById(String id) async {
    var doc = await _authService.currentUser(id);
    return UserModel.fromJson(doc.data().id);
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
