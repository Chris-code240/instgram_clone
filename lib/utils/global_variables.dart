import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instgram_clone/screens/add_post_screen.dart';
import 'package:instgram_clone/screens/home_screen.dart';
import 'package:instgram_clone/screens/profile_screen.dart';
import 'package:instgram_clone/screens/search_screens.dart';

const webScreen = 600;

List<Widget> homeScreenItems = [
  HomeScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("Notifications"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];


// FirebaseAuth.instance.currentUser!.uid
// ProfileScreen(
//     uid: FirebaseAuth.instance.currentUser!.uid,
//   )