import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:let_your_friends_drink/assets/colors.dart';
import 'package:let_your_friends_drink/assets/texts.dart';
import 'package:let_your_friends_drink/blocs/questionaire_cubit/questionaire_cubit.dart';
import 'package:let_your_friends_drink/models/player.dart';

import 'game_screen.dart';

class QuestionaireScreen extends StatefulWidget {
  final List<Player> players;
  const QuestionaireScreen({Key? key, required this.players}) : super(key: key);

  @override
  _QuestionaireScreenState createState() => _QuestionaireScreenState();
}

class _QuestionaireScreenState extends State<QuestionaireScreen> {
  final answerInputController = TextEditingController();

  void addAnswerAndClear(BuildContext context) {
    String answer = answerInputController.text;
    answerInputController.clear();
    context.read<QuestionaireCubit>().saveAnswer(answer);
  }

  void addMultipleAnswer(String answer, BuildContext context) {
    context.read<QuestionaireCubit>().saveAnswer(answer);
  }
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionaireCubit>(
        create: (_) => QuestionaireCubit()..initalizeStates(widget.players),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          backgroundColor: primaryBackground,
          body: Center(
              child: BlocBuilder<QuestionaireCubit, QuestionaireState>(builder: (context, state) {
            if (state is QuestionaireInProgress) {
              if (!state.currentQuestion.isMultiple) {
                return ListView(
                  children: <Widget>[
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
                    	
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: 
                    Container(
                        key: UniqueKey(),
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: startTextColor, borderRadius: BorderRadius.circular(20)),
                        child: Text(state.currentQuestion.text,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: primaryBackground, fontSize: 24)))),
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
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(
                            color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: answerInputController,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: enterAnswer,
                              suffixIcon: IconButton(
                                  splashColor: primaryBackground,
                                  color: primaryBackground,
                                  icon: const Icon(Icons.add),
                                  onPressed: () => addAnswerAndClear(context))),
                        )),
                    const SizedBox(height: 30),
                  ],
                );
              } else {
                return ListView(
                  children: <Widget>[
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
                    	
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: 
                    Container(
                        key: UniqueKey(),
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: startTextColor, borderRadius: BorderRadius.circular(20)),
                        child: Text(state.currentQuestion.text,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: primaryBackground, fontSize: 24)))),
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
                        answers,
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
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: state.players
                            .map((item) => Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(20),
                                height: 90,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                    onPressed: () => addMultipleAnswer(item.name, context),
                                    child: Text(item.name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.permanentMarker(
                                            color: primaryBackground, fontSize: 24)))))
                            .toList()),
                    const SizedBox(height: 30),
                  ],
                );
              }
            } else if (state is QuestionaireEnd) {
              return TextButton(child: Text(start,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.permanentMarker(
                                            color: startTextColor, fontSize: 24)), onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => GameScreen(
                      players: state.players, answers: state.answers, questions: state.questions))),);
            } else {
              return const Text(error);
            }
          })),
        ));
  }
}
