import 'package:flutter/material.dart';

final List<BottomNavigationBarItem> bottomNavItems = [
  BottomNavigationBarItem(
    backgroundColor: Colors.blue,
    icon: Icon(Icons.home),
    label: "主页",
  ),
  BottomNavigationBarItem(
      backgroundColor: Colors.amber,
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: ""),
  BottomNavigationBarItem(
    backgroundColor: Colors.red,
    icon: Icon(Icons.person),
    label: "我",
  ),
];
