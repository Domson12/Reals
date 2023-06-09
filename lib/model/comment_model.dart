import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String uid;
  final String commentId;
  final String postId;
  final String username;
  final String text;
  final String profileImage;
  final datePublished;
  final likes;

  const CommentModel(
      {required this.uid,
      required this.commentId,
        required this.postId,
      required this.username,
      required this.text,
      required this.profileImage,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'commentId': commentId,
        'postId': postId,
        'username': username,
        'text': text,
        'profileImage': profileImage,
        'datePublished': datePublished,
        'likes': likes,
      };

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      uid: snapshot['uid'],
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      text: snapshot['text'],
      profileImage: snapshot['profileImage'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
