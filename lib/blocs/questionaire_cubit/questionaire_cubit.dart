import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:let_your_friends_drink/models/player.dart';
import 'package:let_your_friends_drink/models/question.dart';
import 'dart:math';

part 'questionaire_state.dart';

class QuestionaireCubit extends Cubit<QuestionaireState> {
  QuestionaireCubit() : super(const QuestionaireInitial(players: []));

  void initalizeStates(List<Player> players) {
    emit(QuestionaireInitial(players: players));
    saveAnswer("");
  }

  void saveAnswer(String answer) {
    final currentState = state;
    if (currentState is QuestionaireInitial) {
      List<String> questionDataText = [
        'Zadnji pojam koji sam pretraživao na internetu je _______',
        'Moja omiljena serija je _______',
        'Najviše se bojim _______',
        'Najdraži dio tijela mi je _______',
        'Moj omiljeni superheroj je _______',
        'Moj najdraži film je _______',
        'Moja najgora navika je _______',
        'Životinja na koju ličim dok jedem je _______',
        'Jedna stvar koju bih promijenio na svom tijelu je _______',
        'Najgori poklon koji sam dobio za rođendan je _______',
        'Da sam čokoladica, bio bih _______',
        'Država u koju bih se odselio da mogu je _______',
        'Najvrijednija stvar koju sam ikad ukrao je _______',
      ];

      List<String> questionDataMultiple = [
        'Osoba koja najviše trača je _______',
        'Osoba koju ne bih poveo na putovanje oko svijeta je _______',
        'Osoba koja će najviše popiti u izlasku je _______',
        'Najgluplje fore ima _______',
        '_______ provodi najviše vremena pred ogledalom',
        'Osoba koja najviše laže je _______',
        '_______ će najvjerojatnije završiti u zatvoru',
        '_______ se najmanje tušira',
        'Osoba po kojoj bih nazvao svoje dijete je _______',
        'Osoba s kojom bih se zamijenio na jedan dan je _______',
        '_______ ima najbolji modni izričaj.',
      ];

      Random random = Random();
      List<int> randomTextQuestionIdx = [];
      List<int> randomMultipleQuestionIdx = [];
      List<Question> questions = [];

      int questionsCounter = 0;
      while (questionsCounter < currentState.players.length * 2) {
        int randomIdx = random.nextInt(questionDataText.length);
        if (!randomTextQuestionIdx.contains(randomIdx)) {
          questionsCounter++;
          randomTextQuestionIdx.add(randomIdx);
          questions.add(
              Question(id: randomIdx + 1, text: questionDataText[randomIdx], isMultiple: false));
        } else {
          randomIdx = random.nextInt(questionDataText.length);
        }
      }

      questionsCounter = 0;
      while (questionsCounter < currentState.players.length * 2) {
        int randomIdx = random.nextInt(questionDataMultiple.length);
        if (!randomMultipleQuestionIdx.contains(randomIdx)) {
          questionsCounter++;
          randomMultipleQuestionIdx.add(randomIdx);
          questions.add(Question(
              id: randomIdx + 1 + questionDataText.length,
              text: questionDataMultiple[randomIdx],
              isMultiple: true));
        } else {
          randomIdx = random.nextInt(questionDataMultiple.length);
        }
      }

      Map<int, Map<String, String>> answers = {};

      
      emit(QuestionaireInProgress(
          players: currentState.players,
          questions: questions,
          currentPlayer: currentState.players[0],
          currentQuestion: questions[0],
          currentPlayerIndex: 0,
          currentQuestionIndex: 0,
          answers: answers));
    } else if (currentState is QuestionaireInProgress) {
      if (currentState.currentQuestionIndex == currentState.questions.length - 1 &&
          currentState.currentPlayerIndex == currentState.players.length - 1) {
        emit(QuestionaireEnd(
            players: currentState.players,
            questions: currentState.questions,
            answers: currentState.answers));
      } else {
        Map<int, Map<String, String>> newAnswers = currentState.answers;
        if (newAnswers[currentState.currentQuestion.id] == null) {
          newAnswers[currentState.currentQuestion.id] = <String, String>{};
        }
        newAnswers[currentState.currentQuestion.id]![currentState.currentPlayer.name] = answer;
        int newQuestionIndex = currentState.currentQuestionIndex + 1;
        int newPlayerIndex = currentState.currentPlayerIndex;
        if (newQuestionIndex == currentState.questions.length) {
          newQuestionIndex = 0;
          newPlayerIndex += 1;
        }
        emit(QuestionaireInProgress(
            players: currentState.players,
            questions: currentState.questions,
            currentPlayer: currentState.players[newPlayerIndex],
            currentQuestion: currentState.questions[newQuestionIndex],
            currentPlayerIndex: newPlayerIndex,
            currentQuestionIndex: newQuestionIndex,
            answers: newAnswers));
      }
    }
  }
}
