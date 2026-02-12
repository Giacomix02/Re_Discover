import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/ui/OOBE/oobe.dart';
import 'package:re_discover/ui/OOBE/view_model/oobe_view_model.dart';

class OobeCard extends StatelessWidget {
  const OobeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              children: [
                Icon(Icons.waving_hand, size: 60, color: Colors.yellow[800]),
                const Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("Tell us something about yourself", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What's your name?",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Consumer<OobeViewModel>(
                  builder: (context, oobeViewModel, child) {
                    return Form(
                      key: oobeViewModel.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: oobeViewModel.usernameController,
                            validator: (value) {
                              return oobeViewModel.validateUsername(value);
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.keyboard),
                              hintText: "Insert your name",
                              hintStyle: TextStyle(fontSize: 13),
                              errorMaxLines: 5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (oobeViewModel.formKey.currentState!.validate()) {
                                  oobeViewModel.username = oobeViewModel.usernameController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider.value(
                                        value: oobeViewModel,
                                        child: const OobeCompleted(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.black,
                                ),
                                foregroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.white,
                                ),
                              ),
                              label: const Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
