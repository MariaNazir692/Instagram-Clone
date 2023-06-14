// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/uttils/colors.dart';
// import 'package:instagram_clone/uttils/utils.dart';
// import 'package:instagram_clone/widgets/follow_Btn.dart';
//
// class Profile_Screen extends StatefulWidget {
//   final String Uuid;
//   const Profile_Screen({Key? key, required this.Uuid}) : super(key: key);
//
//   @override
//   State<Profile_Screen> createState() => _Profile_ScreenState();
// }
//
// class _Profile_ScreenState extends State<Profile_Screen> {
//   var userData={};
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }
//   getData() async{
//     try{
//       var snap=await FirebaseFirestore.instance.collection('users').doc(widget.Uuid).get();
//       userData=snap.data()!;
//       setState(() {});
//     }catch(err){
//       showSnackBar(err.toString(), context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: Text(userData['username']),
//         centerTitle: false,
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.grey,
//                       backgroundImage: AssetImage("assets/images/account.jpg"),
//                       radius: 40,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               buildState(20, "Posts"),
//                               buildState(200, "Followers"),
//                               buildState(20, "Following"),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               FollowBtn(
//                                 borderColor: Colors.grey,
//                                 backgroundColor: mobileBackgroundColor,
//                                 textColor: primaryColor,
//                                 txt: "Edit Profile",
//                                 function: () {},
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 15),
//                   child: Text(
//                     "User name",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 15),
//                   child: Text(
//                     "Description or Bio",
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//            Divider(),
//
//         ],
//       ),
//     );
//   }
//
//   Column buildState(int num, String lable) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           num.toString(),
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 4),
//           child: Text(
//             lable,
//             style: TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/FireStoreMathods.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/logIn_screen.dart';
import 'package:instagram_clone/uttils/colors.dart';
import 'package:instagram_clone/uttils/utils.dart';
import 'package:instagram_clone/widgets/follow_Btn.dart';

class Profile_Screen extends StatefulWidget {
  final String uid;

  const Profile_Screen({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      //getting user details
      var Usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //getting user's posts that he have posted to show them on profile screen
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLength = postSnap.docs.length;
      userData = Usersnap.data()!;
      followers = Usersnap.data()!['Followers'].length;
      following = Usersnap.data()!['Following'].length;
      isFollowing = Usersnap.data()!['Followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildState(postLength, "Posts"),
                                    buildState(followers, "Followers"),
                                    buildState(following, "Following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowBtn(
                                            borderColor: Colors.grey,
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            txt: "Sign Out",
                                            function: () async{
                                              await AuthMathods().signOut();
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LogIn_Screen()));
                                            },
                                          )
                                        : isFollowing
                                            ? FollowBtn(
                                                borderColor: Colors.grey,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                txt: "Unfollow",
                                                function: () async {
                                                  await FireStoreMathods()
                                                      .FollowUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing=false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowBtn(
                                                borderColor: Colors.blue,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                txt: "Follow",
                                                function: () async {
                                                  await FireStoreMathods()
                                                      .FollowUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing=true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        // this means there are 3 columns or 3 posts per line
                        crossAxisSpacing: 5,
                        //verticle space
                        mainAxisSpacing: 1.5,
                        //horizontal space
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildState(int num, String lable) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            lable,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
