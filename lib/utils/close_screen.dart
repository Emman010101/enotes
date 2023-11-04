import 'package:flutter/material.dart';

void closeScreen(context){
  //for closing the screen
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}