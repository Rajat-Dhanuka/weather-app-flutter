import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:get/get.dart';

class FirstScreen extends StatelessWidget {
  FirstScreen({super.key});
  final TextEditingController _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Weather App')),
        body: Column(
          children: [
            TextField(
              controller: _cityController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => HomeScreen(cityName: _cityController.text));
                },
                child: const Text("Check the Weather"))
          ],
        ));
  }
}
