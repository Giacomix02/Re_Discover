import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/data/states/user_state.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/gamification_engine/gamification_engine.dart';
import 'package:re_discover/ui/MAP/screens/quiz_completed_screen.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.poi, this.mapViewModel});

  final POI poi;
  final MapViewModel? mapViewModel;

  //TODO: implementare parametri necessari per il quiz
  //TODO: implementare le chiamate al gameEngine tramite funzione nel viewmodel

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}


class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: StateHub().userState,
      child: QuizScreenContent(poi: widget.poi, mapViewModel: widget.mapViewModel),
    );
  }
}


class QuizScreenContent extends StatefulWidget {
  const QuizScreenContent({super.key, required this.poi, this.mapViewModel});

  final POI poi;
  final MapViewModel? mapViewModel;

  @override
  State<QuizScreenContent> createState() => _QuizScreenContentState();
}

class _QuizScreenContentState extends State<QuizScreenContent> {
  late var randomValueQuiz = Random().nextInt(widget.poi.quizzes.length);
  late var randomValueQuestion = Random().nextInt(
    widget.poi.quizzes[randomValueQuiz].questions.length,
  );

  // Dati demo del quiz (possono arrivare da repo/API in futuro)
  late final String _title = "Unlock ${widget.poi.name}";
  late final String _description =
      widget.poi.quizzes[randomValueQuiz].description;
  late final String _question = widget
      .poi
      .quizzes[randomValueQuiz]
      .questions[randomValueQuestion]
      .questionText;
  late final List<String> _answers = widget
      .poi
      .quizzes[randomValueQuiz]
      .questions[randomValueQuestion]
      .answers;

  late final int _correctIndex = widget
      .poi
      .quizzes[randomValueQuiz]
      .questions[randomValueQuestion]
      .correctOptionIndex; // indice della risposta corretta

  bool _errorCommitted = false;

  int _attemptsLeft = 3;

  int? _selectedIndex;

  final Set<int> _wrongAnswers = {}; // Traccia le risposte sbagliate

  void _onConfirm() {
    if (_selectedIndex == null) return;

    final isCorrect = _selectedIndex == _correctIndex;

    if (isCorrect) {
      _handleCorrectAnswer();
      return;
    }

    _handleWrongAnswer();
  }

  void _handleCorrectAnswer() async {
    try {
      GamificationEngine gamificationEngine = GamificationEngine();
      bool isAvailable = await gamificationEngine.getAvailability();

      if (isAvailable) {
        RepositoryHub().userRepository.updateUserXp(_errorCommitted); // revisionato
        RepositoryHub().addPoiVisited(StateHub().userState.user.username);
      }
      
      _navigateToCompletedScreen();
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating progress")),
      );
    }
  }


  void _handleWrongAnswer() {
    setState(() {
      _errorCommitted = true;
      _attemptsLeft = (_attemptsLeft - 1).clamp(0, 3);
      if (_selectedIndex != null) {
        _wrongAnswers.add(_selectedIndex!); // Memorizza la risposta sbagliata
      }
      _selectedIndex = null;
    });

    if (_attemptsLeft == 0) {
      _handleNoAttemptsLeft();
    }
  }

  void _handleNoAttemptsLeft() {
    RepositoryHub().userRepository.updateUserXp(_errorCommitted);
    RepositoryHub().addPoiVisited(StateHub().userState.user.username);
    _navigateToCompletedScreen();
  }

  void _navigateToCompletedScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => QuizCompletedScreen(
          poi: widget.poi,
          attempts_left: _attemptsLeft,
          was_error_committed: _errorCommitted,
          mapViewModel: widget.mapViewModel,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerRight,
          child: Consumer<UserState>(
            builder: (BuildContext context, userState, Widget? child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.track_changes, size: 20, color: Colors.orange),
                  Text(
                    "1500XP",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.diamond, size: 20, color: Colors.pink),
                  Text("${userState.user.gems}", style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                ],
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Row(children: const [Text("Hint")]),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ), // titolo quiz
              const SizedBox(height: 2),
              Text(
                _description,
                style: const TextStyle(fontSize: 16),
              ), // titolo e descrizione quiz
              const SizedBox(height: 2),
              // Sostituito il Container con height fisso con un widget responsive
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: AssetImage(widget.poi.images[0]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              // immagine quiz responsive
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Answer to Unlock",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Attempts: ", style: TextStyle(fontSize: 16)),
                      // indicatori tentativi dinamici
                      ...List.generate(3, (i) {
                        final color = i < _attemptsLeft
                            ? Colors.green
                            : Colors.red;
                        return Row(
                          children: [
                            Icon(Icons.circle, color: color, size: 16),
                            if (i < 2) const SizedBox(width: 4),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ), // titolo sezione domanda e tentativi
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0.5,
                      child: Padding(
                        // padding più responsivo rispetto a valori fissi grandi
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(_question),
                            const SizedBox(height: 10),
                            // Elenco risposte selezionabili
                            ...List.generate(_answers.length, (i) {
                              final selected = _selectedIndex == i;
                              final isWrong = _wrongAnswers.contains(i);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: OutlinedButton(
                                  onPressed: (_attemptsLeft == 0 || isWrong)
                                      ? null
                                      : () {
                                          setState(() => _selectedIndex = i);
                                        },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 12,
                                    ),
                                    side: BorderSide(
                                      color: isWrong
                                          ? Colors.red
                                          : selected
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.grey.shade400,
                                    ),
                                    backgroundColor: isWrong
                                        ? Colors.red.withValues(alpha: 0.12)
                                        : selected
                                            ? Theme.of(context).colorScheme.primary
                                                  .withValues(alpha: 0.12)
                                            : null,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(_answers[i]),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ), // box domanda e risposte
              const SizedBox(height: 10),
              // Bottone conferma a larghezza piena
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_selectedIndex == null || _attemptsLeft == 0)
                          ? null
                          : _onConfirm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor:
                            (_selectedIndex == null || _attemptsLeft == 0)
                            ? null
                            : Colors.green,
                      ),
                      child: const Text(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        "Confirm Answer",
                      ),
                    ),
                  ),
                ],
              ), // bottone conferma risposta
            ],
          ),
        ),
      ),
    );
  }
}
