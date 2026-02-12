import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/data/states/state_hub.dart';
import 'package:re_discover/gamification_engine/gamification_engine.dart';
import 'package:re_discover/ui/HOME/view_model/home_view_model.dart';
import 'package:re_discover/ui/HOME/widgets/home_screen_subwidgets/home_screen_answers_accuracy_cards.dart';
import 'package:re_discover/ui/HOME/widgets/home_screen_subwidgets/home_screen_exploration_button.dart';
import 'package:re_discover/ui/HOME/widgets/home_screen_subwidgets/home_screen_header.dart';
import 'package:re_discover/ui/core/widgets/level_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()..initState()),
        ChangeNotifierProvider.value(value: StateHub().userState),
      ],
      child: HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  
  @override
  Widget build(BuildContext context) {
    Stream<bool> gamificationEngineAvailability = GamificationEngine().getAvailabilityPeriodically();
    final homeViewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: StreamBuilder(
              stream: gamificationEngineAvailability,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                List<Widget> sections = [];
                if (asyncSnapshot.hasData && asyncSnapshot.data!) {
                  sections = [
                    HomeScreenHeader(pfpIdSelected: homeViewModel.selectedPfp, cosmetics: homeViewModel.cosmetics),
                    SizedBox(height: 20),
                    LevelCard(),
                    HomeScreenAnswersAccuracyCards(),
                    SizedBox(height: 20),
                    HomeScreenExplorationButton(isVisiting: context.watch<HomeViewModel>().isVisiting),
                  ];
                } else {
                  sections = [
                    HomeScreenHeader(pfpIdSelected: homeViewModel.selectedPfp, cosmetics: homeViewModel.cosmetics),
                    SizedBox(height: 20),
                    HomeScreenExplorationButton(isVisiting: context.watch<HomeViewModel>().isVisiting),
                    ];
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: sections,
                );
              }
            )
          ),
        ),
      ),
    );
  }
}