import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String name;
  final int score;

  Player({required this.name, this.score = 0});

  @override
  List<Object?> get props => [name, score];
}
