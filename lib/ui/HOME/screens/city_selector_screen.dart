import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/HOME/view_model/city_selector_view_model.dart';
import 'package:re_discover/ui/HOME/widgets/city_selector_subwidgets/city_card.dart';

class CitySelectorScreen extends StatelessWidget {
  const CitySelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CitySelectorViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120.0,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Select a city", style: TextStyle(fontSize: 18)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Consumer<CitySelectorViewModel>(
                    builder: (context, viewModel, child) {
                      return SearchBar(
                        elevation: const WidgetStatePropertyAll<double>(0.7),
                        backgroundColor:
                            const WidgetStatePropertyAll<Color>(Colors.white),
                        hintText: "Search a city",
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        leading: const Icon(Icons.search),
                        onChanged: (value) {
                          viewModel.search(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Consumer<CitySelectorViewModel>(
                builder: (context, viewModel, child) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: viewModel.citiesToDisplay.length,
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: CityCard(city: viewModel.citiesToDisplay[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
