import 'package:championship_tracker/fantacoaches_page.dart';
import 'package:championship_tracker/players_page.dart';
import 'package:championship_tracker/style.dart';
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
          pagesRow(context),
          Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: content,
                ),
              ),
          )
        ],
      )
    );
  }
}

Row pagesRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      BasicStyledButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const PlayersPage();
            }));
          },
          text: "Players"
      ),
      BasicStyledButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FantaCoachesPage();
            }));
          },
          text: "FantaCoaches"
      )
    ],
  );
}



