import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:instagram_clone/resources/storage_mathods.dart';
import 'package:instagram_clone/model/UserModel.dart' as model;

class AuthMathods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser=_auth.currentUser!;

    DocumentSnapshot snap=await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }



  //Sign Up User
  Future<String> SignupUSer({
    required String name,
    required String email,
    required String bio,
    required String password,
    required Uint8List file,
  }) async {
    String res = "Some Error Occured";
    try {
      if (name.isNotEmpty ||
          email.isNotEmpty ||
          bio.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMathods()
            .UploadImageToStorage('Profile_pic', file, false);

        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: name,
            bio: bio,
            Followers: [],
            Following: []
        );

        //Adding USer to Firebase Firestore

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "Success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "Email is badly formatted";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //For Log In User

  Future<String> LogInUser(
      {required String email, required String password}) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please Enter all the Fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//for signout user
  Future<void> signOut()async{
    await _auth.signOut();

  }
}
