import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/SignUp.dart';
import 'package:instagram_clone/screens/forgot_password.dart';
import 'package:instagram_clone/uttils/colors.dart';
import 'package:instagram_clone/uttils/utils.dart';
import 'package:instagram_clone/widgets/text_feild_input.dart';

import '../resources/auth_method.dart';
import '../responsive/mobileScreen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreen_layout.dart';
import '../uttils/global_variables.dart';

class LogIn_Screen extends StatefulWidget {
  const LogIn_Screen({Key? key}) : super(key: key);

  @override
  State<LogIn_Screen> createState() => _LogIn_ScreenState();
}

class _LogIn_ScreenState extends State<LogIn_Screen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isloading = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMathods().LogInUser(
        email: emailController.text, password: passwordController.text);
    if (res == 'Success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Responsive_Layout(
            WebScreenLayout(),
            MobileScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > WebScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                "assets/images/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFeildInput(
                textEditingController: emailController,
                hintText: "Enter Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFeildInput(
                textEditingController: passwordController,
                hintText: "Enter Password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                  foregroundColor: primaryColor,
                  fixedSize: Size(200, 50),
                  shape: StadiumBorder(),
                ),
                child: _isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Text(
                        "Log In".toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                    },
                    child: const Text(
                      "Forget Password",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    )),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account: ",
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 15),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
