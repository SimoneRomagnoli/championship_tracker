import 'package:flutter/material.dart';

abstract class ChampionshipTrackerPage extends StatefulWidget {
  const ChampionshipTrackerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ChampionshipTrackerPageState createState();
}

abstract class ChampionshipTrackerPageState extends State<ChampionshipTrackerPage> {
  ChampionshipTrackerPageState({Key? key});

  abstract Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pagesRow,
          Expanded(child: content)
        ],
      )
    );
  }
}

Row pagesRow = Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    TextButton(
        onPressed: () {},
        child: const Text("First")
    ),
    TextButton(
        onPressed: () {},
        child: const Text("Second")
    )
  ],
);

