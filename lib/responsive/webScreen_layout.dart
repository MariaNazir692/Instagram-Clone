import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../uttils/colors.dart';
import '../uttils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPressed(int page) {
    _pageController.jumpToPage(page);
    setState(() {
      _page=page;
    });
  }

  void OnPageChanged(int page) {
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/images/ic_instagram.svg",
          height: 32,
          color: primaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () =>onPressed(0),
            icon: Icon(
              Icons.home,
              color: _page==0? primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => onPressed(1),
            icon: Icon(
              Icons.search,
              color: _page==1? primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=> onPressed(2),
            icon: Icon(
              Icons.add_a_photo_outlined,
              color: _page==2? primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=> onPressed(3),
            icon: Icon(
              Icons.account_circle_sharp,
              color: _page==3? primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=>onPressed(4),
            icon: Icon(
              Icons.settings,
              color: _page==4? primaryColor:secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        children:homeScreenItems,
        controller: _pageController,
        onPageChanged: OnPageChanged,
        physics: NeverScrollableScrollPhysics(),
      )
    );
  }
}
