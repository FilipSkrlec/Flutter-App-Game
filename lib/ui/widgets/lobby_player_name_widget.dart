import 'package:flutter/material.dart';
import 'package:let_your_friends_drink/assets/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LobbyPlayerNameWidget extends StatelessWidget {
  final String name;
  const LobbyPlayerNameWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        height: 80,
        width: 250,
        decoration: BoxDecoration(color: primaryDetail, borderRadius: BorderRadius.circular(20)),
        child: Text(name, textAlign: TextAlign.center, style: GoogleFonts.permanentMarker(color: primaryBackground, fontSize: 24)));
  }
}
