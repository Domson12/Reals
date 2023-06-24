import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../animation/like_animation.dart';

class CommentCard extends StatefulWidget {
  final snapshot;

  const CommentCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;

  void toggleLikeComment() async {
    final UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (widget.snapshot['likes'].contains(user.uid)) {
      // User has already liked the comment, so remove their like
      widget.snapshot['likes'].remove(user.uid);
    } else {
      // User has not liked the comment, so add their like
      widget.snapshot['likes'].add(user.uid);
    }

    // Update the likes field in the Firestore database
    await FirestoreMethods().likeComment(
      widget.snapshot['postId'],
      user.uid,
      widget.snapshot['likes'],
      widget.snapshot['commentId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snapshot['profileImage']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snapshot['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snapshot['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snapshot['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimating: widget.snapshot['likes'].contains(user.uid),
            smallLike: true,
            child: IconButton(
              onPressed: toggleLikeComment,
              icon: widget.snapshot['likes'].contains(user.uid)
                  ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
                  : const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
