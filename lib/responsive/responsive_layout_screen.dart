import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/uttils/global_variables.dart';
import 'package:provider/provider.dart';

class Responsive_Layout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const Responsive_Layout( this.webScreenLayout, this.mobileScreenLayout,
      {Key? key}) : super(key: key);

  @override
  State<Responsive_Layout> createState() => _Responsive_LayoutState();
}

class _Responsive_LayoutState extends State<Responsive_Layout> {

  @override
  void initState() {
  super.initState();
  addData();

  }

  addData()async{
    UserProvider _userprovider=Provider.of(context, listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth > WebScreenSize ){
            return widget.webScreenLayout;
          }
          return widget.mobileScreenLayout;
        }
    );
  }


}
