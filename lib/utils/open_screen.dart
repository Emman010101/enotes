import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//for opening screens
Future<void> openScreen(BuildContext context, Widget widget) async{
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}