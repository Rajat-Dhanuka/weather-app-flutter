import 'dart:convert'; //used for json
import 'package:intl/intl.dart'; //used to format date
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/data_model.dart';
import 'package:flutter_application_1/data/models/city_model.dart';
import 'package:http/http.dart' as http; //http package used to integrate APIs

class HomeScreen extends StatefulWidget {
  final String cityName;

  HomeScreen({Key? key, required this.cityName});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true; //Loading variable

  //initState function- called before the build function,
  //so we call the Apis and set timers here before we display the UI through build
  @override
  void initState() {
    super.initState();
    _getData();
  }

  DataModel? dataFromAPI;
  CityModel? citydataFromAPI;
  _getData() async {
    String url =
        'https://geocoding-api.open-meteo.com/v1/search?name=${widget.cityName}';
    http.Response res = await http.get(Uri.parse(url));
    citydataFromAPI = CityModel.fromJson(json.decode(res.body));
    url =
        'https://api.open-meteo.com/v1/forecast?latitude=${citydataFromAPI!.results![0].latitude}&longitude=${citydataFromAPI!.results![0].longitude}&hourly=temperature_2m';
    print(url);
    res = await http.get(Uri.parse(
        url)); //the execution will not mve forward until this line is executed due to 'await'
    dataFromAPI = DataModel.fromJson(json.decode(res.body));
    debugPrint(res.body);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cityName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DateTime temp =
                    DateTime.parse(dataFromAPI!.hourly!.time![index]);
                ;
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd-MM--yyyy HH:mm a').format(temp)),
                        Text(dataFromAPI!.hourly!.temperature2m![index]
                            .toString())
                      ]),
                );
              },
              itemCount: dataFromAPI!.hourly!.time!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button is pressed');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
