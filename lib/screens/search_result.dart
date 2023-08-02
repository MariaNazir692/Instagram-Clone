import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/screens/postDetail.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import '../uttils/colors.dart';
import '../uttils/global_variables.dart';

class SearchResult_For_post extends StatefulWidget {
  final String searchStr;

  const SearchResult_For_post({Key? key, required this.searchStr})
      : super(key: key);

  @override
  State<SearchResult_For_post> createState() => _SearchResult_For_postState();
}

class _SearchResult_For_postState extends State<SearchResult_For_post> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;
  bool isPost = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search",
              ),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUser = true;
                  isPost = true;
                });
              },
            ),
            bottom: const TabBar(
              dividerColor: primaryColor,
              physics: ScrollPhysics(),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.drag_handle,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.supervisor_account,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              isPost
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('description', isGreaterThanOrEqualTo: _searchController.text)
                          .where('description', isLessThanOrEqualTo: _searchController.text + '\uf8ff')
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        else if (snapshot.data!.docs.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "No posts found",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[600],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return Container();
                        }
                        else{
                        return StaggeredGridView.countBuilder(
                          crossAxisCount: 3,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(postId: snapshot.data!.docs[index].id)));
                            },
                            child: Image.network(
                              snapshot.data!.docs[index]['postUrl'],
                            ),
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
                        );}
                      })
                  : const Center(child: Text("Not Found")),
              isShowUser
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('username',
                              isGreaterThanOrEqualTo: _searchController.text.trim())
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Profile_Screen(
                                            uid: snapshot.data!.docs[index]
                                                ['uid'],
                                          )));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]['photoUrl'],
                                    ),
                                  ),
                                  title: Text(
                                      snapshot.data!.docs[index]['username']),
                                ),
                              );
                            });
                      },
                    )
                  : const Center(child: Text("Not Found")),
            ],
          )),
    );
  }
}
