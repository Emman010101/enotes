import 'package:flutter/material.dart';

void snackBar(context, text){
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}