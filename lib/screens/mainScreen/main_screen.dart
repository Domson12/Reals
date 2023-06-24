import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reals/utils/colors.dart';
import 'package:reals/utils/global_variables.dart';

import '../../components/widgets/post_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Image.asset(
                'assets/images/logo.png',
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.messenger_outline),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const SnackBar(
              content: Text('some error occured'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  PostCard(snapshot: snapshot.data!.docs[index].data()),
            );
          }
        },
      ),
    );
  }
}
