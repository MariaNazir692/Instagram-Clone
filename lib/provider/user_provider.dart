import 'package:flutter/material.dart';
import 'package:instagram_clone/model/UserModel.dart';
import 'package:instagram_clone/resources/auth_method.dart';

//this is used for statement provider
class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMathods _authMathods=AuthMathods();

  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user=await _authMathods.getUserDetails();
    _user=user;
    //this is the listener to the user data that will tells that data has been changed so you need to update value
   //it will build specific widget not all widget
    notifyListeners();

  }
}