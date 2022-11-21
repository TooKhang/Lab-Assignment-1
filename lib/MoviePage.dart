import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  String name, year, posterlink, genre;
  MoviePage(
      {Key? key,
      required this.name,
      required this.year,
      required this.posterlink,
      required this.genre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Movie Explaination'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(posterlink, scale: 1),
              Text(
                'Movie Name: $name',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Release Year: $year',style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text('Movie Type: $genre',style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
