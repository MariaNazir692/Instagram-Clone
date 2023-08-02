import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/FireStoreMathods.dart';
import 'package:instagram_clone/uttils/colors.dart';
import '../responsive/mobileScreen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreen_layout.dart';
import '../uttils/global_variables.dart';
import '../uttils/utils.dart';
import '../widgets/text_feild_input.dart';

class EditProfileScreen extends StatefulWidget {
  String uid;
  EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isloading=false;
  var userData = {};
  Uint8List? image;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
  getUserData()async {
    try {
    var Usersnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userData = Usersnap.data()!;
    setState(() {});
  }
    catch(err){
      showSnackBar(err.toString(), context);
    }
  }
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }


  editProfile() async {
    setState(() {
      _isloading = true;
    });
   String res= await FireStoreMathods().UpdateProfile(
      uid: widget.uid,
      name: usernameController.text,
      email: emailController.text,
      bio: bioController.text,

    );
    setState(() {
      _isloading = false;
    });

    if (res != 'Success') {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      //Replacement is used when we want not to come back to the current screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Responsive_Layout(
            WebScreenLayout(),
            MobileScreenLayout(),
          ),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              padding: MediaQuery
                  .of(context)
                  .size
                  .width > WebScreenSize ? EdgeInsets.symmetric(
                  horizontal: MediaQuery
                      .of(context)
                      .size
                      .width / 3): const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(image!))
                        : CircleAvatar(
                        radius: 64,
                        backgroundImage:
                        NetworkImage(userData['photoUrl'])),
                    Positioned(
                        bottom: 0,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: usernameController,
                  hintText: userData['username'],
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: emailController,
                  hintText: userData['email'],
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: bioController,
                  hintText: userData['bio'],
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: editProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                    fixedSize: const Size(200, 50),
                    shape: const StadiumBorder(),
                  ),
                  child: _isloading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                      : Text(
                    "Update Profile".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ),
        ),
      ) ,
    );
  }
}
