import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
  final int id;
  final String text;

  const Challenge({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}
