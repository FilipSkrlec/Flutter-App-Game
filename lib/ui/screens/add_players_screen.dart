import 'package:flutter/material.dart';
import 'package:let_your_friends_drink/assets/colors.dart';
import 'package:let_your_friends_drink/assets/texts.dart';
import 'package:let_your_friends_drink/blocs/add_players_cubit/add_players_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_your_friends_drink/models/player.dart';
import 'package:let_your_friends_drink/ui/screens/questionaire_screen.dart';
import 'package:let_your_friends_drink/ui/widgets/lobby_players_list.dart';

class AddPlayersScreen extends StatefulWidget {
  const AddPlayersScreen({Key? key}) : super(key: key);

  @override
  _AddPlayersScreenState createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  final ScrollController _scrollController = ScrollController();

  final playerInputController = TextEditingController();

  void addPlayerAndClear(BuildContext context) {
    String playerName = playerInputController.text;
    playerInputController.clear();
    context.read<AddPlayersCubit>().addPlayer(Player(name: playerName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPlayersCubit>(
        create: (_) => AddPlayersCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          backgroundColor: primaryBackground,
          body: Center(
              child: ListView(
            controller: _scrollController,
            children: <Widget>[
              BlocBuilder<AddPlayersCubit, AddPlayersState>(builder: (context, state) {
                if (state is AddPlayersInitial) {
                  return Column(children: <Widget>[
                    const SizedBox(height: 50),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: playerInputController,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: enterName,
                              suffixIcon: IconButton(color: primaryBackground, icon: const Icon(Icons.add), onPressed: () => addPlayerAndClear(context))),
                        )),
                    const SizedBox(height: 30),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(color: startTextColor, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        child: TextButton(
                          child: const Text(
                            start,
                            style: TextStyle(
                              color: primaryBackground,
                            ),
                          ),
                          onPressed: () =>
                              {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QuestionaireScreen(players: state.players)))},
                        )),
                    const SizedBox(
                      height: 20,
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
                        players,
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
                    const LobbyPlayersList(),
                  ]);
                } else {
                  return Column(children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(color: primaryDetail, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: playerInputController,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: enterName,
                              suffixIcon: IconButton(
                                  color: primaryBackground,
                                  icon: const Icon(Icons.add),
                                  onPressed: () => context.read<AddPlayersCubit>().addPlayer(Player(name: playerInputController.text)))),
                        )),
                    const LobbyPlayersList(),
                  ]);
                }
              }),
            ],
          )),
        ));
  }
}
