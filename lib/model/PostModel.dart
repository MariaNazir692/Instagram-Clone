import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PostModel{

  final String description;
  final String uid;
  final String username;
  final String postId;
  final publisheDate;
  final String postUrl;
  final String profImage;
  final likes;

  const PostModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.publisheDate,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  //take the user detail and convert it in object
  Map<String, dynamic> toJson()=>{
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "publisheDate": publisheDate,
    "postUrl": postUrl,
    "profImage": profImage,
    "Like": likes
  };

  //take a document snapshot and return a user model

  static PostModel fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String, dynamic>;


    return PostModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      publisheDate: snapshot['publishDate'],
      description: snapshot['description'],
      likes: snapshot['likes'],
    );
  }
}
