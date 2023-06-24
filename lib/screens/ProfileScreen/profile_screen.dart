import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reals/components/widgets/build_stat_column.dart';
import 'package:reals/resources/auth_methods.dart';
import '../../components/widgets/profile_button.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../loginScreen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        postLen = postSnap.docs.length;
        userData = userSnap.data()!;
        followers = userSnap.data()!['followers'].length;
        following = userSnap.data()!['following'].length;
        isFollowing = userSnap
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          // User is logged in
          // getData(); // Remove this line to prevent calling during build phase

          return buildProfileScreen();
        } else {
          // User is logged out
          return const LoginScreen();
        }
      },
    );
  }

  Widget buildProfileScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          userData['username'] ?? '',
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  userData['photoUrl'],
                                ),
                                radius: 40,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Text(
                                  userData['username'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(
                                      postLen,
                                      'Posts',
                                    ),
                                    buildStatColumn(
                                      followers,
                                      'Followers',
                                    ),
                                    buildStatColumn(
                                      following,
                                      'Following',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ProfileButton(
                                  onPressed: () {
                                    AuthMethods().signOut();
                                  },
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.black,
                                  text: 'Sign out',
                                  textColor: Colors.black,
                                  padding: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
