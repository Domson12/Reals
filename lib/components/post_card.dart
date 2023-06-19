import 'package:flutter/material.dart';
import 'package:reals/utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                 backgroundImage: NetworkImage(''),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
