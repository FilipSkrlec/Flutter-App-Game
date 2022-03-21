part of 'questionaire_cubit.dart';

abstract class QuestionaireState extends Equatable {
  const QuestionaireState();

  @override
  List<Object?> get props => [];
}

class QuestionaireInitial extends QuestionaireState {
  final List<Player> players;

  const QuestionaireInitial({
    required this.players,
  });

  @override
  List<Object?> get props => [players];
}

class QuestionaireInProgress extends QuestionaireState {
  final List<Player> players;
  final List<Question> questions;
  final Player currentPlayer;
  final Question currentQuestion;
  final int currentPlayerIndex;
  final int currentQuestionIndex;
  final Map<int, Map<String, String>> answers;

  const QuestionaireInProgress(
      {required this.players,
      required this.questions,
      required this.currentPlayer,
      required this.currentQuestion,
      required this.currentPlayerIndex,
      required this.currentQuestionIndex,
      required this.answers});

  @override
  List<Object?> get props => [players, questions, currentPlayer, currentPlayerIndex, currentQuestionIndex, answers];
}

class QuestionaireEnd extends QuestionaireState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String, String>> answers;

  const QuestionaireEnd({required this.players, required this.questions, required this.answers});

  @override
  List<Object?> get props => [players, questions, answers];
}
