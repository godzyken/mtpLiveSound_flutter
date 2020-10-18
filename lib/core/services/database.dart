import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mtpLiveSound/core/models/comment.dart';
import 'package:mtpLiveSound/core/models/post.dart';
import 'package:mtpLiveSound/core/models/user.dart';

import 'api.dart';

class FirestorePath {
  static String post(String uid, String postId) => 'users/$uid/posts/$postId';

  static String posts(String uid) => 'users/$uid/posts';

  static String comment(String uid, String postId, String commentId) =>
      'users/$uid/posts/$postId/comment/$commentId';
}

abstract class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  // CRUD operations
  Stream<List<User>> getUserList();

  Future<void> createUser(User user);

  Future<User> getUserOnFirebase(String id);

  Stream<List<Post>> streamPosts(User user);

  Future<void> addPost(User user, dynamic post);

  Future<void> setPost(Post post);

  Future<void> deletePost(Post post);

  Future<void> removePost(User user, String id);

  Stream<List<Comment>> commentsStream(User user);

  Future<void> setComment(User user, dynamic comment);

  Future<void> deleteComment(User user, String id);
}

class DatabaseService extends FirestoreDatabase {
  final Api _api;
  final String uid;

  DatabaseService(this.uid, {Api api}) : _api = api;

  final _db = FirebaseFirestore.instance;

  /*
  * @Create User
  */
  @override
  Future<void> createUser(User user) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .set({'displayName': 'DogMan ${user.uid.substring(0, 5)}'});
  }

  @override
  Future<User> getUserOnFirebase(String id) async {
    var snap = await _db.collection('users').doc('id').get();

    return User.fromJson(snap.data());
  }

  Stream<User> streamUser(String id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => User.fromJson(snap.data()));
  }

  @override
  Stream<List<User>> getUserList() {
    return _db.collection('user').snapshots().map((snapShot) =>
        snapShot.docs.map((doc) => User.fromJson(doc.data())).toList());
  }

  Stream<QuerySnapshot> get posts {
    return _db.collection('posts').snapshots();
  }

  /*
  * @Create UserPost / UserComment
  */
  @override
  Future<void> addPost(User user, dynamic post) async {
    return _db.collection('users').doc(user.uid).collection('posts').add(post);
  }

  @override
  Stream<List<Post>> streamPosts(User user) {
    var ref = _db.collection('users').doc(user.uid).collection('posts');

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Future<void> setPost(Post post) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('posts')
        .doc(post.id)
        .set({'${post.id}': '${post.body}'});
  }

  @override
  Future<void> removePost(User user, String id) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('posts')
        .doc(id)
        .delete();
  }

  @override
  Future<void> deletePost(Post post) {
    return _db.collection('users').doc(post.id).delete();
  }

  @override
  Future<void> setComment(User user, dynamic comment) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('comments')
        .add(comment);
  }

  @override
  Stream<List<Comment>> commentsStream(User user) {
    var ref = _db.collection('users').doc(user.uid).collection('comments');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Comment.fromSnapshot(doc)).toList());
  }

  @override
  Future<void> deleteComment(User user, String id) async {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('comments')
        .doc(id)
        .delete();
  }
}
