import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'todo/home.dart';

void main() => runApp(const RestApiDemo());

class RestApiDemo extends StatelessWidget {
  const RestApiDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: false),
      home: Home(),
    );
  }
}
