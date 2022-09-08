import 'package:championship_tracker/pages.dart';
import 'package:flutter/material.dart';

import 'db.dart';
import 'nba.dart';

class PlayersPage extends ChampionshipTrackerPage {
  const PlayersPage({super.key}) : super(title: "Players");

  @override
  ChampionshipTrackerPageState createState() => PlayersPageState();
}

class PlayersPageState extends ChampionshipTrackerPageState {
  PlayersPageState();

  @override
  Widget content = Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const Text("NBA Players"),
      Expanded(
        child: FutureBuilder(
          future: getNbaPlayers(),
          builder: buildPlayersGrid,
        ),
      ),
    ],
  );
}

Widget buildPlayersGrid(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
  return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      children: snapshot.hasData
          ? snapshot.data!.map((player) => playerGridRow(player)).expand((e) => e).toList()
          : []
  );
}

List<Widget> playerGridRow(NbaPlayer player) {
  return  [
    Center(child: Text(player.firstName)),
    Center(child: Text(player.lastName)),
    Center(child: Text(player.pos)),
    Center(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        )
    ),
  ];
}