import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class User{

  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List Followers;
  final List Following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.Followers,
    required this.Following,
});

  //take the user detail and convert it in object
  Map<String, dynamic> toJson()=>{
    "username": username,
    "uid": uid,
    "photoUrl": photoUrl,
    "email": email,
    "bio": bio,
    "Followers": Followers,
    "Following": Following
  };

  //take a document snapshot and return a user model

static User fromSnap(DocumentSnapshot snap){
  var snapshot=snap.data() as Map<String, dynamic>;
  return User(
    username: snapshot['username'],
    uid: snapshot['uid'],
    photoUrl: snapshot['photoUrl'],
    email: snapshot['email'],
    bio: snapshot['bio'],
    Followers: snapshot['Followers'],
    Following: snapshot['Following'],
  );
}



}