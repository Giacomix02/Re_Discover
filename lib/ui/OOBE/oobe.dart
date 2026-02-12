import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/OOBE/subwidgets/oobe_card.dart';
import 'package:re_discover/ui/OOBE/subwidgets/oobe_completed_card.dart';
import 'package:re_discover/ui/OOBE/view_model/oobe_view_model.dart';

// Entrypoint for OOBE
class Oobe extends StatelessWidget {
  const Oobe({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OobeViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [OobeCard()],
            ),
          ),
        ),
      ),
    );
  }
}

// OOBE completed screen
class OobeCompleted extends StatefulWidget {
  const OobeCompleted({super.key});

  @override
  State<OobeCompleted> createState() => _OobeCompletedState();
}

class _OobeCompletedState extends State<OobeCompleted> {
  late Future<bool> _isUserCorrectlyLoaded;

  @override
  void initState() {
    super.initState();
    _isUserCorrectlyLoaded = Provider.of<OobeViewModel>(context, listen: false).saveTemporaryUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isUserCorrectlyLoaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 5),
                  Text("Setting up your experience...")
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Something went wrong')));
        }
        return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [OobeCompletedCard()],
                ),
              ),
            ),
        );
      }
    );
  }
}
