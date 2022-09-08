import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import 'navbar/navbar.dart';

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
          Container(
            decoration: navbarDecoration,
            child: topNavbar(context),
          ),
          Expanded(
              child: Center(
                child: Padding(
                  padding: defaultPadding,
                  child: content,
                ),
              ),
          )
        ],
      )
    );
  }
}



