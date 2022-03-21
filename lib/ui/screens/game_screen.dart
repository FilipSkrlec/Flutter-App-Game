import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:let_your_friends_drink/assets/colors.dart';
import 'package:let_your_friends_drink/assets/texts.dart';
import 'package:let_your_friends_drink/blocs/game_cubit/game_cubit.dart';
import 'package:let_your_friends_drink/models/player.dart';
import 'package:let_your_friends_drink/models/question.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final Map<int, Map<String, String>> answers;
  final List<Question> questions;
  const GameScreen(
      {Key? key, required this.players, required this.answers, required this.questions})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void submitAnswer(BuildContext context, String answer, int fortuneItemsCount) {
    context.read<GameCubit>().checkAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
        create: (_) =>
            GameCubit()..initalizeStates(widget.players, widget.questions, widget.answers),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          backgroundColor: primaryBackground,
          body: Center(child: BlocBuilder<GameCubit, GameState>(builder: (context, state) {
            if (state is GameTextQuestionState) {
              return ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(plays,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(color: primaryDetail, fontSize: 20)),
                      Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(20),
                          height: 70,
                          width: 150,
                          decoration: BoxDecoration(
                              color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                          child: Text(state.currentPlayer.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.permanentMarker(
                                  color: primaryBackground, fontSize: 20))),
                    ],
                  ),
                  AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: Container(
                          key: UniqueKey(),
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: startTextColor, borderRadius: BorderRadius.circular(20)),
                          child: Text(state.currentQuestion.text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(color: primaryBackground, fontSize: 24)))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(questionAbout,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(color: primaryDetail, fontSize: 20)),
                      Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(20),
                          height: 70,
                          width: 150,
                          decoration: BoxDecoration(
                              color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                          child: Text(state.aboutPlayer.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.permanentMarker(
                                  color: primaryBackground, fontSize: 20))),
                    ],
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: const Divider(
                            color: primaryDetail,
                            height: 50,
                          )),
                    ),
                    const Text(
                      answer,
                      style: TextStyle(color: primaryDetail),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: const Divider(
                            color: primaryDetail,
                            height: 50,
                          )),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: state.possibleAnswers
                          .map((item) => AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                  key: UniqueKey(),
                                  margin: const EdgeInsets.all(15),
                                  padding: const EdgeInsets.all(20),
                                  height: 90,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: primaryDetail,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextButton(
                                      onPressed: () =>
                                          submitAnswer(context, item!, state.players.length),
                                      child: Text(item ?? "",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.permanentMarker(
                                              color: primaryBackground, fontSize: 24))))))
                          .toList())
                ],
              );
            } else if (state is GameMultipleQuestionState) {
              return ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(plays,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(color: primaryDetail, fontSize: 20)),
                      Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(20),
                          height: 70,
                          width: 150,
                          decoration: BoxDecoration(
                              color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                          child: Text(state.currentPlayer.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.permanentMarker(
                                  color: primaryBackground, fontSize: 20))),
                    ],
                  ),
                  AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: Container(
                          key: UniqueKey(),
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: startTextColor, borderRadius: BorderRadius.circular(20)),
                          child: Text(state.currentQuestion.text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(color: primaryBackground, fontSize: 24)))),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: const Divider(
                            color: primaryDetail,
                            height: 50,
                          )),
                    ),
                    const Text(
                      answer,
                      style: TextStyle(color: primaryDetail),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: const Divider(
                            color: primaryDetail,
                            height: 50,
                          )),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: state.possibleAnswers
                          .map((item) => AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                  key: UniqueKey(),
                                  margin: const EdgeInsets.all(15),
                                  padding: const EdgeInsets.all(20),
                                  height: 90,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: primaryDetail,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextButton(
                                      onPressed: () =>
                                          submitAnswer(context, item, state.players.length),
                                      child: Text(item,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.permanentMarker(
                                              color: primaryBackground, fontSize: 24))))))
                          .toList())
                ],
              );
            } else if (state is GameChallengeState) {
              StreamController<int> wheelOfFortuneController = StreamController<int>();
              return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(plays,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.permanentMarker(color: primaryDetail, fontSize: 20)),
                    Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(20),
                        height: 70,
                        width: 150,
                        decoration: BoxDecoration(
                            color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                        child: Text(state.playerChallenge.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.permanentMarker(
                                color: primaryBackground, fontSize: 20))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(correctAnswers,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(color: startTextColor, fontSize: 20)),
                    const SizedBox(width: 20,),
                    Text(state.correctAnswers.join(" | "),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(color: startTextColor, fontSize: 20)),
                  ],
                ),
                FortuneBar(
                  selected: wheelOfFortuneController.stream,
                  items: state.fortuneItems,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(challenge,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(color: startTextColor, fontSize: 24)),
                      onPressed: () => context.read<GameCubit>().displayChallenge(),
                    ),
                    const SizedBox(
                        height: 60, width: 20, child: VerticalDivider(color: primaryDetail)),
                    TextButton(
                      child: Text(next,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.permanentMarker(color: startTextColor, fontSize: 24)),
                      onPressed: () => context.read<GameCubit>().nextQuestion(),
                    )
                  ],
                )
              ]);
            } else if (state is GameDisplayChallengeState) {
              return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(state.challenges[0].text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(color: primaryDetail, fontSize: 24)),
                ),
                TextButton(
                  child: Text(next,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(color: startTextColor, fontSize: 24)),
                  onPressed: () => context.read<GameCubit>().nextQuestion(),
                )
              ]);
            } else if (state is GameEndState) {
              return const Text(end);
            } else {
              return const Text(error);
            }
          })),
        ));
  }
}
