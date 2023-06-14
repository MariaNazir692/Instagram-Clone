import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import '../screens/edit_profileScreen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const WebScreenSize = 600;
 List<Widget> homeScreenItems = [
  const FeedScreen(),
  const Search_Screen(),
  const addPostScreen(),
  Profile_Screen(uid: FirebaseAuth.instance.currentUser!.uid,),
  EditProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];
