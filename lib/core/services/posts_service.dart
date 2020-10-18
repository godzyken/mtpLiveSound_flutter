
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtpLiveSound/core/models/post.dart';

import 'api.dart';

class PostsService {
  final FirebaseFirestore storageReference = FirebaseFirestore.instance;

  Api _api;

  List<Post> posts;

  Uint8List get data => null;

  Future<List<Post>> getPostsForUser() async {
    var result = await _api.getDataCollection();
    posts = result.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList();

    final FirebaseFirestore uploadTask =
        storageReference.collection('posts').firestore;
    final StreamSubscription<PostsService> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    await uploadTask.onComplete;
    streamSubscription.cancel();

    return posts;
  }
}