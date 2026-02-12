import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/main_view_model.dart';
import 'package:re_discover/ui/OOBE/oobe.dart';
import 'package:re_discover/ui/core/ui/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/states/state_hub.dart';

// Main method that runs the first widget: MyApp
void main() async{
  await dotenv.load(fileName: ".env");

  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re:Discover',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider(
        create: (_) => MainViewModel(),
        child: const InitialScreen(),
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late Future<bool> _shouldOobeBeRunned;

  @override
  void initState() {
    super.initState();
    _shouldOobeBeRunned = Provider.of<MainViewModel>(context, listen: false).shouldOobeBeRunned();

    // Carica i POI count dopo l'inizializzazione
    StateHub().visitState.getPOIsCount().catchError((e) {
      debugPrint('Errore nel caricamento dei POI: $e');
    });
    RepositoryHub().cosmeticRepository.initializeSelectedPfp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _shouldOobeBeRunned,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Something went wrong')));
        }
        final shouldOobe = snapshot.data ?? true;
        return shouldOobe ? Oobe() : HomePage();
      },
    );
  }
}