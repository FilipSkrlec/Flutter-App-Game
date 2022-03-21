import 'package:flutter/material.dart';
import 'package:let_your_friends_drink/assets/texts.dart';
import 'assets/colors.dart';
import 'ui/screens/add_players_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF950740, primaryMaterialColor),
      ),
      home: const AddPlayersScreen(),
    );
  }
}
