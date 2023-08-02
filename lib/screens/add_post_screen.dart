import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/FireStoreMathods.dart';
import 'package:instagram_clone/uttils/utils.dart';
import 'package:provider/provider.dart';
import '../model/UserModel.dart' as model;
import '../uttils/colors.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({Key? key}) : super(key: key);

  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  Uint8List? _file;
  String description = "";

  // final TextEditingController _textEditingController = TextEditingController();
  bool _isloading = false;
  final _auth = FirebaseAuth.instance;

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: primaryColor,
          title: const Text("Create a Post",
              style: TextStyle(color: Colors.black)),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Take a Photo",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from gallery",
                  style: TextStyle(color: Colors.black)),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black)),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  postImage(String uid, String username, String profImage) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FireStoreMathods().uploadPost(
        description,
        uid,
        _file!,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(
            msg: "Posted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0);
        clearImage();
      } else {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(
            msg: "Posted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0);
        clearImage();
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // @override
  // // void dispose() {
  // //   // TODO: implement dispose
  // //   super.dispose();
  // //   _textEditingController.dispose();
  // // }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  //For #tag list of tags that will be added or that the user can add

  List<Map<String, dynamic>> data = [
    {'Internships': 'internship'},
    {'job': 'job'},
    {'Cooking': 'Cooking'},
    {'Hair Style': 'HairStyle'},
    {'Fashion': 'Fashion'},
    {'app development': 'app_development'},
    {'Politics': 'Politics'},
    {'Wedding planner': 'weddingPlanner'},
    {'education': 'education'},
    {'graphics': 'graphics'},
    {'hijabi': 'hijabi'},
    {'punjabi': 'punjabi'},
    {
      'username': '_auth.username'
          'photoUrl:'
          '_auth.photoUrl'
    },
    {'': ''},
  ];
  final GlobalKey<FlutterMentionsState> _key = GlobalKey<FlutterMentionsState>();

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text("Post to"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        description=_key.currentState!.controller!.text;
                      });
                      postImage(user.uid, user.username, user.photoUrl);
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isloading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(user.photoUrl),
                    ),
                    description == ""
                        ? Container()
                        : Text(
                            description,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                    FlutterMentions(
                      key: _key,
                      decoration: const InputDecoration(
                        hintText: "Enter caption",
                      ),
                      maxLines: 8,
                      mentions: [
                        Mention(
                            trigger: '#',
                            data: data,
                            style: const TextStyle(color: Colors.blue),
                            suggestionBuilder: (data) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                color: Colors.grey,
                              );
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      //child of aspect ratio will be consistent with width and height
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
