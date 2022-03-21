part of 'add_players_cubit.dart';

abstract class AddPlayersState extends Equatable {
  const AddPlayersState();

  @override
  List<Object?> get props => [];
}

class AddPlayersInitial extends AddPlayersState {
  final List<Player> players;

  const AddPlayersInitial({
    required this.players,
  });

  @override
  List<Object?> get props => [players];
}
