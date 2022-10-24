
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

/// Input decoration for the zefyr field and fields
InputDecoration furdemInputDecoration(String placeholder, String counter, String label) => InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.grey[800], width: 1),
  ),
  labelText: label,
  counterText: counter,
  hintText: placeholder,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.black, width: 1),
  ),
);


///Zefyr Theme Data
ZefyrThemeData zefyrThemeData = ZefyrThemeData(
  codeSnippetStyle: CodeSnippetStyle.sunburst,
  code: TextBlockTheme(
    decoration: BoxDecoration(
        color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
    style: TextStyle(
      color: Colors.white,
      fontSize: 13,
      height: 1.15,
    ),
    spacing: VerticalSpacing(top: 6, bottom: 10),
  ),
  bold: TextStyle(
    color: Colors.blue[900]
  )
);
