import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/PostModel.dart';
import 'package:instagram_clone/resources/storage_mathods.dart';
import 'package:instagram_clone/uttils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMathods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String uid, Uint8List file,
      String username, String profImage) async {
    String res = "Some Error occured";
    try {
      String photoUrl =
          await StorageMathods().UploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        publisheDate: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List like) async {
    try {
      //For disliking the post
      //this will be happen if the liked post already in our like array in db then
      // after this that user's post will be desliked and removed from our like array in db
      if (like.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          //it tells to go to the likes field and take that array and
          // remove current user id to dislike it
          'Like': FieldValue.arrayRemove([uid])
        });
      } //for liking the post
      else {
        await _firestore.collection('posts').doc(postId).update({
          //it tells to go to the likes field and take that array and add
          // current user id to like it
          'Like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String uid, String text, String name,
      String profPic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profPic,
          'name': name,
          'commentId': commentId,
          'uid': uid,
          'text': text,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //For Deleting the post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> FollowUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['Following'];
      if (followId.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'Followers': FieldValue.arrayRemove(['uid'])
        });
        await _firestore.collection('users').doc(uid).update({
          'Following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'Followers': FieldValue.arrayUnion(['uid'])
        });
        await _firestore.collection('users').doc(uid).update({
          'Following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {}
  }

  Future<void> sharePost(String postId) async {
    var snap = await _firestore.collection('posts').doc(postId).get();
    Share.share(snap['postUrl']);
  }

  Future<String> UpdateProfile({
    required String uid,
    required String name,
    required String email,
    required String bio,
  }) async {
    String res = "Some Error occured";
    try{
      _firestore.collection('users').doc(uid).update({
        'username': name,
        'email':email,
        'bio':bio,
      });
      res="Success";
      Fluttertoast.showToast(
          msg: "Profile updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0
      );
    }catch(err){
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    return res;
  }
}
