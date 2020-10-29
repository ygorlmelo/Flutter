import 'package:flutter/material.dart';

import 'pages/PaginaLogin.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: PaginaLogin(),
  ));
}
