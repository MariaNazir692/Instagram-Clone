import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/uttils/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _editingController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Forgot Password"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _editingController,
              decoration: const InputDecoration(
                hintText: "Enter Registered Email",
                hintStyle: TextStyle(color: Colors.black45),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: UpdatePassword,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                foregroundColor: primaryColor,
                fixedSize: const Size(200, 50),
              ),
              child: const Text(
                "Send Email Link",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void UpdatePassword() {
    _auth
        .sendPasswordResetEmail(email: _editingController.text.toString())
        .then((value) => {
              Fluttertoast.showToast(
                  msg:
                      "Email has been sent to you please check your email to reset your password",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0)
            })
        .onError((error, stackTrace) => {
              Fluttertoast.showToast(
                  msg: error.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0)
            });
  }
}
