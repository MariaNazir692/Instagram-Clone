import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_result.dart';
import 'package:instagram_clone/uttils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../uttils/global_variables.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search for user",
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SearchResult_For_post (searchStr: _searchController.text)));
            },
            icon: Icon(
              Icons.search,
            ),
          )
        ],
      ),
      //we are getting data of users of our app from firebase that's why we are using future builder
      body:
          //   ? FutureBuilder(
          // future: FirebaseFirestore.instance
          //     .collection('users')
          //     .where('username',
          //     isGreaterThanOrEqualTo: _searchController.text)
          //     .get(),
          // builder: (context,
          //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //   if (!snapshot.hasData) {
          //     return Center(child: const CircularProgressIndicator());
          //   }
          //   return ListView.builder(
          //       itemCount: snapshot.data!.docs.length,
          //       itemBuilder: (context, index) {
          //         return InkWell(
          //           onTap: () {
          //             Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) =>
          //                     Profile_Screen(
          //                       uid: snapshot.data!.docs[index]['uid'],
          //                     )));
          //           },
          //           child: ListTile(
          //             leading: CircleAvatar(
          //               backgroundImage: NetworkImage(
          //                 snapshot.data!.docs[index]['photoUrl'],
          //               ),
          //             ),
          //             title: Text(snapshot.data!.docs[index]['username']),
          //           ),
          //         );
          //       });
          // },)
      FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                  ),
                  staggeredTileBuilder: (index) =>
                      MediaQuery.of(context).size.width > WebScreenSize
                          ? StaggeredTile.count(
                              (index % 7 == 0) ? 1 : 1,
                              (index % 7 == 0) ? 1 : 1,
                            )
                          : StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1,
                            ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}
