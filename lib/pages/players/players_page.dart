import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../../api/db.dart';
import '../../api/nba.dart';

BoxDecoration listTileDecoration = const BoxDecoration(
  border: Border(
      bottom: BorderSide(
        color: Colors.black12,
      ),
      top: BorderSide(
        color: Colors.black12,
      ),
  ),
);

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
          builder: buildPlayersList,
        ),
      ),
    ],
  );
}

Widget buildPlayersList(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
  return Container(
    padding: EdgeInsets.zero,
    decoration: defaultContainerDecoration,
    child: snapshot.hasData ? ListView.builder(
        itemBuilder: (_, int index) {
          return ListTile(
            minVerticalPadding: -1.0,
            contentPadding: EdgeInsets.zero,
            title: Container(
              padding: defaultPadding,
              decoration: listTileDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex:25, child: Text(snapshot.data![index].firstName)),
                  Expanded(flex:25, child: Text(snapshot.data![index].lastName)),
                  Expanded(flex:25, child: Center(child: Text(snapshot.data![index].pos))),
                  Expanded(flex:25, child: BasicStyledButton(text: "+", onPressed: () {})),
                ],
              ),
            ),
          );
        }
    ) : Row(),
  );
}
