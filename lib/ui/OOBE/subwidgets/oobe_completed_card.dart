import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/OOBE/view_model/oobe_view_model.dart';
import 'package:re_discover/ui/core/ui/homepage.dart';

class OobeCompletedCard extends StatelessWidget {
  const OobeCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const Text(
                  "Configuration completed!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<OobeViewModel>(
                    builder: (context, oobeViewModel, child) {
                      return ElevatedButton.icon(
                          onPressed: () => {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (r) => false
                            )},
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Colors.black,
                            ),
                            foregroundColor: WidgetStatePropertyAll<Color>(
                              Colors.white,
                            ),
                          ),
                          label: const Text("Begin your adventure"),
                          icon: Icon(Icons.rocket_launch)
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
