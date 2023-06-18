import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reals/model/post.dart';
import 'package:reals/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload a Post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String resource = 'some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        postId: postId,
        postUrl: photoUrl,
        username: username,
        description: description,
        profileImage: profileImage,
        datePublished: DateTime.now(),
        likes: [],
      );
      _firestore.collection('post').doc(postId).set(
            post.toJson(),
          );
      resource = 'success';
    } catch (e) {
      resource = e.toString();
    }
    return resource;
  }
}
