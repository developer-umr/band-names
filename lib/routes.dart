import 'package:bandnames/pages/home.dart';
import 'package:bandnames/pages/status.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    HomePage.routeName: (_)=>HomePage(),
    StatusPage.routeName: (_)=>StatusPage()
  };
}