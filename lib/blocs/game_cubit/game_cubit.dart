import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:let_your_friends_drink/models/challenge.dart';
import 'package:let_your_friends_drink/models/player.dart';
import 'package:let_your_friends_drink/models/question.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameInitial(players: [], questions: [], answers: {}, challenges: []));

  void initalizeStates(
      List<Player> players, List<Question> questions, Map<int, Map<String, String>> answers) {
    Random random = Random();
    List<String> challengesData = [
      'Neka vam ostali naprave novu frizuru',
      'Stavi sliku osobe koja je bila točan odgovor kao profilnu sliku na Instagramu/Facebooku na jedan dan',
      'Napravi 10 sklekova',
      'Napravi 10 čučnjeva',
      'Zamijeni majicu s osobom s tvoje lijeve strane i nosi ju iduća 2 kruga',
      'Pokaži svima zadnjih 5 inboxa s Whatsappa',
      'Neka te osoba prekoputa našminka po svom izboru',
      'Neka ti osoba 2 mjesta lijevo od tebe nacrta tetovažu na leđima',
      'Napravi selfie s WC papirom i stavi ga na story za bliske prijatelje',
      'Promijeni status veze na Facebooku u komplicirano je',
      'Okreni majicu naopako i nosi ju tako do kraja igre',
      'U obraz poljubi osobu za koju misliš da je najgluplja',
      'S osobom s vaše desne strane otplešite neki ples u paru na pjesmu po izboru',
      'Zagrlite osobu koju najmanje volite',
      'Recite svima koliko ste najviše potrošili na alkohol u jednom izlasku',
      'Napravi plank od 1 minute',
      'Postani rob osobi 2 mjesta lijevo od tebe na iduća 2 kruga.',
      'Pojedi 1 ljutu papričicu.',
      'Napravi 20 trbušnjaka.',
      'Pravi se da si pas u iduća 2 kruga.',
    ];
    challengesData.shuffle();
    List<Challenge> challenges = [];
    for (var i = 0; i < challengesData.length; i++) {
      challenges.add(Challenge(id: i + 1, text: challengesData[i]));
    }
    /*for (int i = 0; i < 40; i++) {
      challengesData.add('A');
    }
    List<int> randomChallengeIdx = [];
    int challengesCounter = 0;
    while (challengesCounter < players.length * 4) {
      int randomIdx = random.nextInt(challengesData.length);
      if (!randomChallengeIdx.contains(randomIdx)) {
        randomChallengeIdx.add(randomIdx);
        challenges.add(Challenge(id: randomIdx + 1, text: challengesData[randomIdx]));
        challengesCounter += 1;
      } else {
        randomIdx = random.nextInt(challengesData.length);
      }
    }
    */
    emit(GameInitial(
        players: players, questions: questions, answers: answers, challenges: challenges));
    nextQuestion();
  }

  void nextQuestion() {
    final currentState = state;
    if (currentState is GameInitial) {
      List<Question> shuffledQuestions = [];
      for (var question in currentState.questions) {
        if (question.isMultiple == false) {
          shuffledQuestions.add(question);
        }
      }
      shuffledQuestions.shuffle();
      List<Question> shuffledQuestionsMultiple = [];
      for (var question in currentState.questions) {
        if (question.isMultiple == true) {
          shuffledQuestionsMultiple.add(question);
        }
      }
      shuffledQuestionsMultiple.shuffle();
      shuffledQuestions.addAll(shuffledQuestionsMultiple);
      List<Player> shuffledPlayers = currentState.players;
      shuffledPlayers.shuffle();
      Question currentQuestion = shuffledQuestions[0];
      Player currentPlayer = shuffledPlayers[0];

      List<Question> remainingQuestions = [];
      for (var i = 0; i < shuffledQuestions.length; i++) {
        remainingQuestions.add(shuffledQuestions[i]);
      }
      List<Player> remainingPlayers = [];
      for (var i = 1; i < shuffledPlayers.length; i++) {
        remainingPlayers.add(shuffledPlayers[i]);
      }

      int remainingRounds = 2;
      Player aboutPlayer = remainingPlayers[0];
      String? correctAnswer = currentState.answers[currentQuestion.id]![aboutPlayer.name];
      List<String?> possibleAnswers = [];
      possibleAnswers.add(correctAnswer);
      Random random = Random();
      List<String> alreadyUsedAnswerNames = [];
      List<String> leftAnswerNames = [];
      for (var player in currentState.players) {
        if (player.name != currentPlayer.name && player.name != aboutPlayer.name) {
          leftAnswerNames.add(player.name);
        }
      }
      alreadyUsedAnswerNames.add(currentPlayer.name);
      alreadyUsedAnswerNames.add(aboutPlayer.name);
      int numOfPossibleAnswers = 0;
      if (currentState.players.length >= 5) {
        numOfPossibleAnswers = 4;
      } else {
        numOfPossibleAnswers = currentState.players.length - 1;
      }
      for (var i = 0; i < numOfPossibleAnswers - 1; i++) {
        String randName = leftAnswerNames[random.nextInt(leftAnswerNames.length)];
        if (!alreadyUsedAnswerNames.contains(randName)) {
          alreadyUsedAnswerNames.add(randName);
          possibleAnswers.add(currentState.answers[currentQuestion.id]![randName]);
          leftAnswerNames.remove(randName);
        }
      }
      possibleAnswers.shuffle();
      emit(GameTextQuestionState(
          players: shuffledPlayers,
          questions: shuffledQuestions,
          answers: currentState.answers,
          currentPlayer: currentPlayer,
          currentQuestion: currentQuestion,
          remainingPlayers: remainingPlayers,
          remainingQuestions: remainingQuestions,
          remainingRounds: remainingRounds,
          correctAnswer: correctAnswer,
          possibleAnswers: possibleAnswers,
          aboutPlayer: aboutPlayer,
          challenges: currentState.challenges));
    } else if (currentState is GameChallengeState) {
      if (currentState.remainingQuestions.length == 1) {
        emit(const GameEndState());
      } else {
        int remainingRounds = currentState.remainingRounds;
        Player aboutPlayer = currentState.currentPlayer;
        Player currentPlayer = currentState.currentPlayer;
        Question currentQuestion = currentState.remainingQuestions[1];
        List<Player> remainingPlayers = currentState.remainingPlayers;
        List<Question> remainingQuestions = currentState.remainingQuestions;
        currentState.challenges.removeAt(0);

        if (currentQuestion.isMultiple) {
          if (currentState.remainingPlayers.isEmpty && currentState.remainingRounds > 1) {
            remainingRounds = 1;
            List<Player> shuffledPlayers = currentState.players;
            shuffledPlayers.shuffle();
            Player currentPlayer = shuffledPlayers[0];

            List<Player> remainingPlayers = [];
            for (var i = 1; i < shuffledPlayers.length; i++) {
              remainingPlayers.add(shuffledPlayers[i]);
            }
            List<String> possibleAnswers = [];
            for (var i = 0; i < currentState.players.length; i++) {
              possibleAnswers.add(currentState.players[i].name);
            }
            Map<String, int> answersCounter = {};

            for (var i = 0; i < currentState.players.length; i++) {
              int counter = 0;
              for (var answer in currentState.answers[currentQuestion.id]!.values) {
                if (answer == currentState.players[i].name) {
                  counter++;
                }
              }
              answersCounter[currentState.players[i].name] = counter;
            }
            List<String> correctAnswers = [];

            int topAnswersCount = answersCounter.values.reduce(max);
            answersCounter.forEach((key, value) {
              if (value == topAnswersCount) {
                correctAnswers.add(key);
              }
            });
            remainingQuestions.removeAt(0);

            emit(GameMultipleQuestionState(
                players: shuffledPlayers,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswers: correctAnswers,
                possibleAnswers: possibleAnswers,
                challenges: currentState.challenges));
          } else {
            if (currentState.remainingPlayers.isEmpty) {
              List<Player> shuffledPlayers = currentState.players;
              shuffledPlayers.shuffle();
              currentPlayer = shuffledPlayers[0];

              for (var i = 0; i < shuffledPlayers.length; i++) {
                remainingPlayers.add(shuffledPlayers[i]);
              }
            }
            List<String> possibleAnswers = [];
            for (var i = 0; i < currentState.players.length; i++) {
              possibleAnswers.add(currentState.players[i].name);
            }
            Map<String, int> answersCounter = {};

            for (var i = 0; i < currentState.players.length; i++) {
              int counter = 0;
              for (var answer in currentState.answers[currentQuestion.id]!.values) {
                if (answer == currentState.players[i].name) {
                  counter++;
                }
              }
              answersCounter[currentState.players[i].name] = counter;
            }
            List<String> correctAnswers = [];

            int topAnswersCount = answersCounter.values.reduce(max);
            answersCounter.forEach((key, value) {
              if (value == topAnswersCount) {
                correctAnswers.add(key);
              }
            });

            currentPlayer = remainingPlayers[0];

            remainingPlayers.removeAt(0);
            remainingQuestions.removeAt(0);

            emit(GameMultipleQuestionState(
                players: currentState.players,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswers: correctAnswers,
                possibleAnswers: possibleAnswers,
                challenges: currentState.challenges));
          }
        }

        if (!currentQuestion.isMultiple) {
          if (currentState.remainingPlayers.isEmpty && currentState.remainingRounds > 1) {
            remainingRounds = 1;
            List<Player> shuffledPlayers = currentState.players;
            shuffledPlayers.shuffle();
            currentPlayer = shuffledPlayers[0];
            aboutPlayer = shuffledPlayers[1];

            List<Player> remainingPlayers = [];
            for (var i = 1; i < shuffledPlayers.length; i++) {
              remainingPlayers.add(shuffledPlayers[i]);
            }

            String? correctAnswer = currentState.answers[currentQuestion.id]![aboutPlayer.name];
            List<String?> possibleAnswers = [];
            possibleAnswers.add(correctAnswer);
            Random random = Random();
            List<String> alreadyUsedAnswerNames = [];
            alreadyUsedAnswerNames.add(currentPlayer.name);
            alreadyUsedAnswerNames.add(aboutPlayer.name);
            for (var i = 0; i < 3; i++) {
              while (true) {
                String randName =
                    currentState.players[random.nextInt(currentState.players.length)].name;
                if (!alreadyUsedAnswerNames.contains(randName)) {
                  alreadyUsedAnswerNames.add(randName);
                  possibleAnswers.add(currentState.answers[currentQuestion.id]![randName]);
                  break;
                }
              }
            }
            possibleAnswers.shuffle();
            remainingQuestions.removeAt(0);
            emit(GameTextQuestionState(
                players: shuffledPlayers,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswer: correctAnswer,
                possibleAnswers: possibleAnswers,
                aboutPlayer: aboutPlayer,
                challenges: currentState.challenges));
          } else {
            if (currentState.remainingPlayers.length == 1) {
              currentPlayer = currentState.remainingPlayers[0];
              aboutPlayer = currentState.players[0];
              remainingPlayers.removeAt(0);
              remainingQuestions.removeAt(0);
            } else {
              currentPlayer = currentState.remainingPlayers[0];
              aboutPlayer = currentState.remainingPlayers[1];
              remainingPlayers.removeAt(0);
              remainingQuestions.removeAt(0);
            }

            String? correctAnswer = currentState.answers[currentQuestion.id]![aboutPlayer.name];
            List<String?> possibleAnswers = [];
            possibleAnswers.add(correctAnswer);
            Random random = Random();
            List<String> alreadyUsedAnswerNames = [];
            alreadyUsedAnswerNames.add(currentPlayer.name);
            alreadyUsedAnswerNames.add(aboutPlayer.name);
            for (var i = 0; i < 3; i++) {
              while (true) {
                String randName =
                    currentState.players[random.nextInt(currentState.players.length)].name;
                if (!alreadyUsedAnswerNames.contains(randName)) {
                  alreadyUsedAnswerNames.add(randName);
                  possibleAnswers.add(currentState.answers[currentQuestion.id]![randName]);
                  break;
                }
              }
            }
            possibleAnswers.shuffle();
            emit(GameTextQuestionState(
                players: currentState.players,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswer: correctAnswer,
                possibleAnswers: possibleAnswers,
                aboutPlayer: aboutPlayer,
                challenges: currentState.challenges));
          }
        }
      }
    } else if (currentState is GameDisplayChallengeState) {
      if (currentState.remainingQuestions.length == 1) {
        emit(const GameEndState());
      } else {
        int remainingRounds = currentState.remainingRounds;
        Player aboutPlayer = currentState.currentPlayer;
        Player currentPlayer = currentState.currentPlayer;
        Question currentQuestion = currentState.remainingQuestions[1];
        List<Player> remainingPlayers = currentState.remainingPlayers;
        List<Question> remainingQuestions = currentState.remainingQuestions;
        currentState.challenges.removeAt(0);

        if (currentQuestion.isMultiple) {
          if (currentState.remainingPlayers.isEmpty && currentState.remainingRounds > 1) {
            remainingRounds = 1;
            List<Player> shuffledPlayers = currentState.players;
            shuffledPlayers.shuffle();
            Player currentPlayer = shuffledPlayers[0];

            List<Player> remainingPlayers = [];
            for (var i = 1; i < shuffledPlayers.length; i++) {
              remainingPlayers.add(shuffledPlayers[i]);
            }
            List<String> possibleAnswers = [];
            for (var i = 0; i < currentState.players.length; i++) {
              possibleAnswers.add(currentState.players[i].name);
            }
            Map<String, int> answersCounter = {};

            for (var i = 0; i < currentState.players.length; i++) {
              int counter = 0;
              for (var answer in currentState.answers[currentQuestion.id]!.values) {
                if (answer == currentState.players[i].name) {
                  counter++;
                }
              }
              answersCounter[currentState.players[i].name] = counter;
            }
            List<String> correctAnswers = [];

            int topAnswersCount = answersCounter.values.reduce(max);
            answersCounter.forEach((key, value) {
              if (value == topAnswersCount) {
                correctAnswers.add(key);
              }
            });
            remainingQuestions.removeAt(0);

            emit(GameMultipleQuestionState(
                players: shuffledPlayers,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswers: correctAnswers,
                possibleAnswers: possibleAnswers,
                challenges: currentState.challenges));
          } else {
            List<String> possibleAnswers = [];
            for (var i = 0; i < currentState.players.length; i++) {
              possibleAnswers.add(currentState.players[i].name);
            }

            if (currentState.remainingPlayers.isEmpty) {
              List<Player> shuffledPlayers = currentState.players;
              shuffledPlayers.shuffle();
              currentPlayer = shuffledPlayers[0];

              for (var i = 0; i < shuffledPlayers.length; i++) {
                remainingPlayers.add(shuffledPlayers[i]);
              }

              remainingRounds = 2;
            }

            Map<String, int> answersCounter = {};

            for (var i = 0; i < currentState.players.length; i++) {
              int counter = 0;
              for (var answer in currentState.answers[currentQuestion.id]!.values) {
                if (answer == currentState.players[i].name) {
                  counter++;
                }
              }
              answersCounter[currentState.players[i].name] = counter;
            }
            List<String> correctAnswers = [];

            int topAnswersCount = answersCounter.values.reduce(max);
            answersCounter.forEach((key, value) {
              if (value == topAnswersCount) {
                correctAnswers.add(key);
              }
            });

            currentPlayer = remainingPlayers[0];

            remainingPlayers.removeAt(0);
            remainingQuestions.removeAt(0);

            emit(GameMultipleQuestionState(
                players: currentState.players,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswers: correctAnswers,
                possibleAnswers: possibleAnswers,
                challenges: currentState.challenges));
          }
        }

        if (!currentQuestion.isMultiple) {
          if (currentState.remainingPlayers.isEmpty && currentState.remainingRounds > 1) {
            remainingRounds = 1;
            List<Player> shuffledPlayers = currentState.players;
            shuffledPlayers.shuffle();
            currentPlayer = shuffledPlayers[0];
            aboutPlayer = shuffledPlayers[1];

            List<Player> remainingPlayers = [];
            for (var i = 1; i < shuffledPlayers.length; i++) {
              remainingPlayers.add(shuffledPlayers[i]);
            }

            String? correctAnswer = currentState.answers[currentQuestion.id]![aboutPlayer.name];
            List<String?> possibleAnswers = [];
            possibleAnswers.add(correctAnswer);
            Random random = Random();
            List<String> alreadyUsedAnswerNames = [];
            alreadyUsedAnswerNames.add(currentPlayer.name);
            alreadyUsedAnswerNames.add(aboutPlayer.name);
            for (var i = 0; i < 3; i++) {
              while (true) {
                String randName =
                    currentState.players[random.nextInt(currentState.players.length)].name;
                if (!alreadyUsedAnswerNames.contains(randName)) {
                  alreadyUsedAnswerNames.add(randName);
                  possibleAnswers.add(currentState.answers[currentQuestion.id]![randName]);
                  break;
                }
              }
            }
            possibleAnswers.shuffle();
            remainingQuestions.removeAt(0);
            emit(GameTextQuestionState(
                players: shuffledPlayers,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswer: correctAnswer,
                possibleAnswers: possibleAnswers,
                aboutPlayer: aboutPlayer,
                challenges: currentState.challenges));
          } else {
            if (currentState.remainingPlayers.length == 1) {
              currentPlayer = currentState.remainingPlayers[0];
              aboutPlayer = currentState.players[0];
              remainingPlayers.removeAt(0);
              remainingQuestions.removeAt(0);
            } else {
              currentPlayer = currentState.remainingPlayers[0];
              aboutPlayer = currentState.remainingPlayers[1];
              remainingPlayers.removeAt(0);
              remainingQuestions.removeAt(0);
            }

            String? correctAnswer = currentState.answers[currentQuestion.id]![aboutPlayer.name];
            List<String?> possibleAnswers = [];
            possibleAnswers.add(correctAnswer);
            Random random = Random();
            List<String> alreadyUsedAnswerNames = [];
            alreadyUsedAnswerNames.add(currentPlayer.name);
            alreadyUsedAnswerNames.add(aboutPlayer.name);
            for (var i = 0; i < 3; i++) {
              while (true) {
                String randName =
                    currentState.players[random.nextInt(currentState.players.length)].name;
                if (!alreadyUsedAnswerNames.contains(randName)) {
                  alreadyUsedAnswerNames.add(randName);
                  possibleAnswers.add(currentState.answers[currentQuestion.id]![randName]);
                  break;
                }
              }
            }
            possibleAnswers.shuffle();
            emit(GameTextQuestionState(
                players: currentState.players,
                questions: currentState.questions,
                answers: currentState.answers,
                currentPlayer: currentPlayer,
                currentQuestion: currentQuestion,
                remainingPlayers: remainingPlayers,
                remainingQuestions: remainingQuestions,
                remainingRounds: remainingRounds,
                correctAnswer: correctAnswer,
                possibleAnswers: possibleAnswers,
                aboutPlayer: aboutPlayer,
                challenges: currentState.challenges));
          }
        }
      }
    }
  }

  void checkAnswer(String? answer) {
    final currentState = state;
    if (currentState is GameTextQuestionState) {
      if (answer == currentState.correctAnswer) {
        int numOfChallenges = (currentState.players.length / 2).ceil();
        List<FortuneItem> fortuneItems = [];
        for (var i = 0; i < numOfChallenges; i++) {
          fortuneItems.add(const FortuneItem(child: Text("IZAZOV")));
        }
        for (var i = numOfChallenges; i < currentState.players.length; i++) {
          fortuneItems.add(const FortuneItem(child: Text("FREE")));
        }
        fortuneItems.shuffle();
        List<String> correctAnswers = [];
        correctAnswers.add(currentState.correctAnswer ?? "");
        emit(GameChallengeState(
            players: currentState.players,
            questions: currentState.questions,
            answers: currentState.answers,
            currentPlayer: currentState.currentPlayer,
            currentQuestion: currentState.currentQuestion,
            remainingPlayers: currentState.remainingPlayers,
            remainingQuestions: currentState.remainingQuestions,
            remainingRounds: currentState.remainingRounds,
            playerChallenge: currentState.aboutPlayer,
            numOfChallenges: numOfChallenges,
            fortuneItems: fortuneItems,
            challenges: currentState.challenges,
            correctAnswers: correctAnswers));
      } else {
        int numOfChallenges = (currentState.players.length / 2).ceil();
        List<FortuneItem> fortuneItems = [];
        for (var i = 0; i < numOfChallenges; i++) {
          fortuneItems.add(const FortuneItem(child: Text("IZAZOV")));
        }
        for (var i = numOfChallenges; i < currentState.players.length; i++) {
          fortuneItems.add(const FortuneItem(child: Text("FREE")));
        }
        fortuneItems.shuffle();
        List<String> correctAnswers = [];
        correctAnswers.add(currentState.correctAnswer ?? "");
        emit(GameChallengeState(
            players: currentState.players,
            questions: currentState.questions,
            answers: currentState.answers,
            currentPlayer: currentState.currentPlayer,
            currentQuestion: currentState.currentQuestion,
            remainingPlayers: currentState.remainingPlayers,
            remainingQuestions: currentState.remainingQuestions,
            remainingRounds: currentState.remainingRounds,
            playerChallenge: currentState.currentPlayer,
            numOfChallenges: numOfChallenges,
            fortuneItems: fortuneItems,
            challenges: currentState.challenges,
            correctAnswers: correctAnswers));
      }
    } else if (currentState is GameMultipleQuestionState) {
      if (currentState.correctAnswers.contains(answer)) {
        int numOfChallenges = currentState.players.length;
        for (var a in currentState.answers[currentState.currentQuestion.id]!.values) {
          if (a == answer) {
            numOfChallenges--;
          }
        }

        List<FortuneItem> fortuneItems = [];
        for (var i = 0; i < numOfChallenges; i++) {
          fortuneItems.add(const FortuneItem(child: Text("IZAZOV")));
        }
        for (var i = numOfChallenges; i < currentState.players.length; i++) {
          fortuneItems.add(const FortuneItem(child: Text("FREE")));
        }
        fortuneItems.shuffle();
        int playerIdx = 0;
        for (var i = 0; i < currentState.players.length; i++) {
          if (currentState.players[i].name == answer) {
            playerIdx = i;
          }
        }
        emit(GameChallengeState(
            players: currentState.players,
            questions: currentState.questions,
            answers: currentState.answers,
            currentPlayer: currentState.currentPlayer,
            currentQuestion: currentState.currentQuestion,
            remainingPlayers: currentState.remainingPlayers,
            remainingQuestions: currentState.remainingQuestions,
            remainingRounds: currentState.remainingRounds,
            playerChallenge: currentState.players[playerIdx],
            numOfChallenges: numOfChallenges,
            fortuneItems: fortuneItems,
            challenges: currentState.challenges,
            correctAnswers: currentState.correctAnswers));
      } else {
        int numOfChallenges = 0;
        for (var a in currentState.answers[currentState.currentQuestion.id]!.values) {
          if (a == answer) {
            numOfChallenges++;
          }
        }

        List<FortuneItem> fortuneItems = [];
        for (var i = 0; i < numOfChallenges; i++) {
          fortuneItems.add(const FortuneItem(child: Text("IZAZOV")));
        }
        for (var i = numOfChallenges; i < currentState.players.length; i++) {
          fortuneItems.add(const FortuneItem(child: Text("FREE")));
        }
        fortuneItems.shuffle();

        emit(GameChallengeState(
            players: currentState.players,
            questions: currentState.questions,
            answers: currentState.answers,
            currentPlayer: currentState.currentPlayer,
            currentQuestion: currentState.currentQuestion,
            remainingPlayers: currentState.remainingPlayers,
            remainingQuestions: currentState.remainingQuestions,
            remainingRounds: currentState.remainingRounds,
            playerChallenge: currentState.currentPlayer,
            numOfChallenges: numOfChallenges,
            fortuneItems: fortuneItems,
            challenges: currentState.challenges,
            correctAnswers: currentState.correctAnswers));
      }
    }
  }

  void displayChallenge() {
    final currentState = state;
    if (currentState is GameChallengeState) {
      emit(GameDisplayChallengeState(
          players: currentState.players,
          questions: currentState.questions,
          answers: currentState.answers,
          currentPlayer: currentState.currentPlayer,
          currentQuestion: currentState.currentQuestion,
          remainingPlayers: currentState.remainingPlayers,
          remainingQuestions: currentState.remainingQuestions,
          remainingRounds: currentState.remainingRounds,
          playerChallenge: currentState.playerChallenge,
          numOfChallenges: currentState.numOfChallenges,
          fortuneItems: currentState.fortuneItems,
          challenges: currentState.challenges,
          correctAnswers: currentState.correctAnswers));
    }
  }
}
