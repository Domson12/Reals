import 'package:flutter/material.dart';
import 'package:reals/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > webScreenSize) {
        //if size is 600 returns web screen
        return webScreenLayout;
      }
      //if size is below 600 return mobile screen
      return mobileScreenLayout;
    });
  }
}
