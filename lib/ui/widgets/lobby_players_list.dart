import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_your_friends_drink/assets/texts.dart';
import 'package:let_your_friends_drink/blocs/add_players_cubit/add_players_cubit.dart';
import 'package:let_your_friends_drink/ui/widgets/lobby_player_name_widget.dart';

class LobbyPlayersList extends StatelessWidget {
  const LobbyPlayersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      child: BlocBuilder<AddPlayersCubit, AddPlayersState>(
        builder: (context, state) {
          if (state is AddPlayersInitial) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: state.players.map((item) => LobbyPlayerNameWidget(name: item.name)).toList());
          } else {
            return const Text(error);
          }
        },
      ),
    );
  }
}
