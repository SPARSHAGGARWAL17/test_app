import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:test_app/app-config.dart';
import 'package:test_app/view/profile-form.dart';

void main() {
  GlobalConfiguration().loadFromMap(appSettings);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProfileFormPage(),
    );
  }
}
