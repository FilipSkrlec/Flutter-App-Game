import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String text;
  final bool isMultiple;

  const Question({required this.id, required this.text, required this.isMultiple});

  @override
  List<Object?> get props => [id, text, isMultiple];
}
