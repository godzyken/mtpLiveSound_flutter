import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth.dart' as auth;

class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Path path;
  CollectionReference ref;

  Api({this.path}) {
    ref = _db.collection('path');
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }
}

class Path {
  static String user(String uid) => 'user/$uid';

  static String post(String uid, String postId) => 'users/$uid/posts/$postId';

  static String posts(String uid) => 'users/$uid/posts';

  static String comment(String uid, String postId, String commentId) =>
      'users/$uid/posts/$postId/comment/$commentId';
}

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient _client;

  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    if (_client == null)
      // _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
/*
    var storage = Storage(_client, 'Image Upload Google Storage');

    var bucket = storage.bucket('mtplivesound.appspot.com');

    return await bucket.writeBytes(name, imgBytes);*/
      return null;
  }
}
