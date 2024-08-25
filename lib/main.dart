import 'package:flutter/material.dart';
import 'package:myapp/home.dart';

import 'credentials.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataScreen(
        credentials: credentials,
        spreadsheetId: spreadsheetId,
      ),
    );
  }
}
