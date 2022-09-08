import 'package:championship_tracker/pages/fantacoaches/fantacoaches_page.dart';
import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
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
          topNavbar(context),
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

Widget topNavbar(BuildContext context) {
  return Padding(
    padding: defaultPadding,
    child: Row(
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
    )
  );
}



