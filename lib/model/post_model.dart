import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String postId;
  final String postUrl;
  final String username;
  final String description;
  final String profileImage;
  final datePublished;
  final likes;

  const PostModel(
      {required this.uid,
      required this.postId,
      required this.postUrl,
      required this.username,
      required this.description,
      required this.profileImage,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'postId': postId,
        'postUrl': postUrl,
        'username': username,
        'description': description,
        'profileImage': profileImage,
        'datePublished': datePublished,
        'likes': likes,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      username: snapshot['username'],
      description: snapshot['description'],
      profileImage: snapshot['profileImage'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
