import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:reals/model/comment_model.dart';
import 'package:reals/model/post_model.dart';
import 'package:reals/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profileImage,
      ) async {
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
        uid: uid,
        postId: postId,
        postUrl: photoUrl,
        username: username,
        description: description,
        profileImage: profileImage,
        datePublished: DateTime.now(),
        likes: [],
      );
      await _firestore.collection('post').doc(postId).set(
        post.toJson(),
      );
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> likeComment(String postId, String uid, List likes, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String> addComment(
      String postId,
      String text,
      String uid,
      String username,
      String profileImage,
      ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        CommentModel comment = CommentModel(
          uid: uid,
          commentId: commentId,
          postId: postId,
          username: username,
          text: text,
          profileImage: profileImage,
          datePublished: DateTime.now(),
          likes: [],
        );
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          comment.toJson(),
        );
        return 'success';
      } else {
        return 'text is empty';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deletePost(String postId) async {
    try {
      await _firestore.collection('post').doc(postId).delete();
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  Future<String> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
      return 'success';
    } catch (e) {
      rethrow;
    }
  }
}
