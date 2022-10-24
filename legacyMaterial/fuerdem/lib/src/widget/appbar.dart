import 'package:flutter/material.dart';

/// The page white app bar with back icon
AppBar simpleAppBar(BuildContext context,{@required String title, List<Widget> actions, IconData icon}) =>
    AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      leading: IconButton(
        icon: Icon(icon ?? Icons.arrow_back_ios_rounded),
        splashRadius: 16,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: actions,
      elevation: 0,
      centerTitle: true,
    );