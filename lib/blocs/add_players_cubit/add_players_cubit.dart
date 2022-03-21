import 'dart:io';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:let_your_friends_drink/models/player.dart';

part 'add_players_state.dart';

class AddPlayersCubit extends Cubit<AddPlayersState> {
  AddPlayersCubit() : super(AddPlayersInitial(players: const []));

  void addPlayer(Player player) {
    final currentState = state;
    if (currentState is AddPlayersInitial) {
      List<Player> newPlayersList = [];
      newPlayersList.addAll(currentState.players);
      newPlayersList.add(player);
      emit(AddPlayersInitial(players: newPlayersList));
    }
  }
}
