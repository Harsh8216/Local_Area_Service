import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/Dashboard_Activity.dart';
import 'package:my_notebook/MyDataList.dart';

class BottomNavBar extends StatefulWidget{
  final VoidCallback onDrawerOpen;
  BottomNavBar({required this.onDrawerOpen});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.fastEaseInToSlowEaseOut,
          height: 60,
          color: Colors.deepPurple,
          backgroundColor: Colors.white,
          items: [
            Icon(Icons.home,size: 30,color: Colors.white,),
            Icon(Icons.add_chart,size: 30,color: Colors.white,),
            Icon(Icons.account_circle,size: 30,color: Colors.white),

          ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyDataList()));
        }
        if (index == 2) {
          widget.onDrawerOpen();

        }

      }
      );
  }
}