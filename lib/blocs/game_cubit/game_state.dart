part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String,String>> answers;
  final List<Challenge> challenges;

  const GameInitial({
    required this.players,
    required this.questions,
    required this.answers,
    required this.challenges
  });

  @override
  List<Object?> get props => [players, questions, answers, challenges];
}

class GameTextQuestionState extends GameState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String,String>> answers;
  final Player currentPlayer;
  final Question currentQuestion;
  final List<Player> remainingPlayers;
  final List<Question> remainingQuestions;
  final int remainingRounds;
  final String? correctAnswer;
  final List<String?> possibleAnswers;
  final Player aboutPlayer;
  final List<Challenge> challenges;

    const GameTextQuestionState({
      required this.players,
      required this.questions,
      required this.answers,
      required this.currentPlayer,
      required this.currentQuestion,
      required this.remainingPlayers,
      required this.remainingQuestions,
      required this.remainingRounds,
      required this.correctAnswer,
      required this.possibleAnswers,
      required this.aboutPlayer,
      required this.challenges
  });

  @override
  List<Object?> get props => [players, questions, answers, currentPlayer, currentQuestion, remainingPlayers, remainingQuestions, remainingRounds, correctAnswer, possibleAnswers, aboutPlayer, challenges];
}

class GameMultipleQuestionState extends GameState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String,String>> answers;
  final Player currentPlayer;
  final Question currentQuestion;
  final List<Player> remainingPlayers;
  final List<Question> remainingQuestions;
  final int remainingRounds;
  final List<String> correctAnswers;
  final List<String> possibleAnswers;
  final List<Challenge> challenges;

    const GameMultipleQuestionState({
      required this.players,
      required this.questions,
      required this.answers,
      required this.currentPlayer,
      required this.currentQuestion,
      required this.remainingPlayers,
      required this.remainingQuestions,
      required this.remainingRounds,
      required this.correctAnswers,
      required this.possibleAnswers,
      required this.challenges
  });

  @override
  List<Object?> get props => [players, questions, answers, currentPlayer, currentQuestion, remainingPlayers, remainingQuestions, remainingRounds, correctAnswers, possibleAnswers, challenges];
}

class GameChallengeState extends GameState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String,String>> answers;
  final Player currentPlayer;
  final Question currentQuestion;
  final List<Player> remainingPlayers;
  final List<Question> remainingQuestions;
  final int remainingRounds;
  final Player playerChallenge;
  final int numOfChallenges;
  final List<FortuneItem> fortuneItems;
  final List<Challenge> challenges;
  final List<String> correctAnswers;

    const GameChallengeState({
      required this.players,
      required this.questions,
      required this.answers,
      required this.currentPlayer,
      required this.currentQuestion,
      required this.remainingPlayers,
      required this.remainingQuestions,
      required this.remainingRounds,
      required this.playerChallenge,
      required this.numOfChallenges,
      required this.fortuneItems,
      required this.challenges,
      required this.correctAnswers
  });

  @override
  List<Object?> get props => [players, questions, answers, currentPlayer, currentQuestion, remainingPlayers, remainingQuestions, remainingRounds, playerChallenge, numOfChallenges, fortuneItems, challenges, correctAnswers];
}

class GameDisplayChallengeState extends GameState {
  final List<Player> players;
  final List<Question> questions;
  final Map<int, Map<String,String>> answers;
  final Player currentPlayer;
  final Question currentQuestion;
  final List<Player> remainingPlayers;
  final List<Question> remainingQuestions;
  final int remainingRounds;
  final Player playerChallenge;
  final int numOfChallenges;
  final List<FortuneItem> fortuneItems;
  final List<Challenge> challenges;
  final List<String> correctAnswers;

    const GameDisplayChallengeState({
      required this.players,
      required this.questions,
      required this.answers,
      required this.currentPlayer,
      required this.currentQuestion,
      required this.remainingPlayers,
      required this.remainingQuestions,
      required this.remainingRounds,
      required this.playerChallenge,
      required this.numOfChallenges,
      required this.fortuneItems,
      required this.challenges,
      required this.correctAnswers
  });

  @override
  List<Object?> get props => [players, questions, answers, currentPlayer, currentQuestion, remainingPlayers, remainingQuestions, remainingRounds, playerChallenge, numOfChallenges, fortuneItems, challenges, correctAnswers];
}

class GameEndState extends GameState {

  const GameEndState();
}


