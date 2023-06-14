import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_method.dart';

import '../responsive/mobileScreen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreen_layout.dart';
import '../uttils/colors.dart';
import '../uttils/global_variables.dart';
import '../uttils/utils.dart';
import '../widgets/text_feild_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'logIn_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  Uint8List? image;
  bool _isloading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  void SignUpUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMathods().SignupUSer(
        name: usernameController.text,
        email: emailController.text,
        bio: bioController.text,
        password: passwordController.text,
        file: image!);

    setState(() {
      _isloading = false;
    });

    if (res != 'Success') {
      showSnackBar(res, context);
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
                    .width / 3):EdgeInsets.symmetric(horizontal: 32),
            margin: EdgeInsets.only(top: 50),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(
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
                                AssetImage("assets/images/ccount.png")),
                    Positioned(
                        bottom: 0,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: usernameController,
                  hintText: "Enter Name",
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: emailController,
                  hintText: "Enter Email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: passwordController,
                  hintText: "Enter Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFeildInput(
                  textEditingController: bioController,
                  hintText: "Enter Bio",
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: SignUpUser,
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Text(
                          "Sign Up".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                    fixedSize: Size(200, 50),
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account: ",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LogIn_Screen();
                        }));
                      },
                      child: Text(
                        "SignIn",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 15),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
