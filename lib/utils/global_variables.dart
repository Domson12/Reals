
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reals/screens/ProfileScreen/profile_screen.dart';
import 'package:reals/screens/addPostScreen/add_post_screen.dart';
import 'package:reals/screens/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:reals/screens/searchScreen/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const MainScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  Text('favourite'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
