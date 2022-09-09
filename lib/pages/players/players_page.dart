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

  Map<String, bool> positions = { "G" : false, "F" : false, "C" : false };
  
  List<NbaPlayer> applyFilters(List<NbaPlayer> players) {
    return players.where(
            (p) => !positions.values.reduce((acc, e) => acc || e) ||
                p.pos.contains(RegExp(positions.keys.where((k) => positions[k]!).reduce((acc, s) => "$acc|$s")))
    ).toList();
  }

  Widget buildPlayersList(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return Container(
        padding: EdgeInsets.zero,
        decoration: defaultContainerDecoration,
        child: snapshot.hasData
            ? ListView(
              children: applyFilters(snapshot.data!)
                  .map((p) => ListTile(
                  minVerticalPadding: -1.0,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    padding: defaultPadding,
                    decoration: listTileDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:25, child: Text(p.firstName)),
                        Expanded(flex:25, child: Text(p.lastName)),
                        Expanded(flex:25, child: Center(child: Text(p.pos))),
                        Expanded(flex:25, child: BasicStyledButton(text: "+", onPressed: () {})),
                      ],
                    ),
                  ),
                )
              ).toList()
            )
            : Row(),
    );
  }

  @override
  Widget content(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const Padding(
        padding: defaultPadding,
        child: Text("NBA Players",
          style: TextStyle(
              fontSize: defaultFontSize * 1.5,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      Container(
        decoration: defaultContainerDecoration,
        padding: defaultPadding,
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: defaultPadding,
                child: const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search"
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child:  BasicStyledButton(
                text: "Positions",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Wrap(
                      children: [
                        AlertDialog(
                          title: const Text('Filter By Position'),
                          content: Container(
                            decoration: defaultContainerDecoration,
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: positions.keys
                                  .map((k) =>
                                    CheckboxListTile(
                                        title: Text(k),
                                        value: positions[k],
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            positions[k] = newValue!;
                                          });
                                          Navigator.pop(context);
                                        }
                                    )
                                  ).toList()
                            )
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Go Back'),
                            ),
                          ],
                        )
                      ],
                    )
                  );
                },
              )
            )
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: getNbaPlayers(),
          builder: buildPlayersList,
        ),
      ),
    ],
  );
}

Widget buildTeamsFilter(BuildContext context, AsyncSnapshot<List<NbaTeam>> snapshot) {
  return DropdownButton<String>(
    value: "CHI",
    onChanged: (_) {},
    items: snapshot.hasData
        ? snapshot.data!.map((team) => DropdownMenuItem<String>(
          value: team.tricode,
          child: CheckboxListTile(
            title: Text(team.tricode),
            value: true,
            onChanged: (_) {},
          )
        )).toList()
        : []
  );
}

