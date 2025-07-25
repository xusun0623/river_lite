import 'package:flutter/cupertino.dart';

final appNavigator = GlobalKey<NavigatorState>();
int inWebView = 0;
bool vpnEnabled = false;
String vpnCookie = "";