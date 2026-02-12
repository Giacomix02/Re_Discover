import 'package:flutter/material.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';

class QuizCompletedScreen extends StatefulWidget {
  const QuizCompletedScreen({
    super.key,
    required this.poi,
    required this.attempts_left,
    required this.was_error_committed,
    this.mapViewModel,
  });

  //TODO: implementare la presa dell'utente, gli xp guadagnati, e altre info necessarie per aumentare di livello/xp

  final POI poi;
  final int attempts_left;
  final bool was_error_committed;
  final MapViewModel? mapViewModel;


  @override
  State<StatefulWidget> createState() => _QuizCompletedScreenState();
}

class _QuizCompletedScreenState extends State<QuizCompletedScreen> {

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.attempts_left == 0 ? 0 : ((widget.attempts_left / 3) * 100).truncate();
    final allAnswersWrong = widget.attempts_left == 0 ? true : false;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,0,20,20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(allAnswersWrong ? Icons.sentiment_very_dissatisfied  : Icons.trending_up_outlined, size: 100, color: Colors.amber),
              Text(
                allAnswersWrong ? "Better luck next time!" : "Quiz Completed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.poi.name,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 3,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Correct answers ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${widget.attempts_left > 0 ? 1 : 0}",
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Wrong answers ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${widget.attempts_left >= 0 ? 3 - widget.attempts_left : 0}",
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "XP Gained",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "+${widget.attempts_left < 3 ? 10 : 25} XP",
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Color.fromARGB(255, 21, 93, 252),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total accuracy",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "$accuracy%",
                              style: TextStyle(
                                fontSize: 26,
                                color: Color.fromARGB(255, 3, 2, 19),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: accuracy / 100,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.grey[300],
                              color: Color.fromARGB(255, 3, 2, 19),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Color.fromARGB(255, 3, 2, 19),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    // Mark POI as completed before going back
                    if (widget.mapViewModel != null) {
                      widget.mapViewModel!.markPoiAsCompleted(widget.poi.id);
                    }
                    // Pop all screens: QuizCompletedScreen, QuizScreen, and POI modal
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ), // bottone per andare avanti
            ],
          ),
        ),
      ),
    );
  }
}
