import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_application/MoviePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Form(),
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class Form extends StatefulWidget {
  const Form({Key? key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  final TextEditingController _moviename = TextEditingController();
  var searchname = "", releasedYear = "", movieposterLink = "", movieType = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Star Movie App",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset('assets/images/movie.png', scale: 0.5),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                    controller: _moviename,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your favourite movie name')),
              ),
              ElevatedButton(
                  onPressed: _showMyDialog, child: const Text("Search Movie")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comfirmation Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you want to search this movie?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _progressindicator();
                _searchmovie();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _progressindicator() {
    showDialog(
      context: context,
      builder: (context) {
        const Duration(seconds: 3);
        EasyLoading.addStatusCallback((status) {
          print('EasyLoading Status $status');
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        EasyLoading.showSuccess('Search Success');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _searchmovie() async {
    _progressindicator();
    searchname = _moviename.text;
    var url =
        Uri.parse('https://www.omdbapi.com/?t=$searchname&apikey=231981c5');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      releasedYear = parsedJson['Year'];
      movieposterLink = parsedJson['Poster'];
      movieType = parsedJson['Genre'];

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MoviePage(
              name: _moviename.text,
              year: releasedYear,
              posterlink: movieposterLink,
              genre: movieType)));
    }
  }
}
