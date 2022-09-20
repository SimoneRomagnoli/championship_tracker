import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/pages/players/filters.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/tuples.dart';
import 'package:flutter/material.dart';

import '../../api/db.dart';
import '../../api/fanta.dart';
import '../../api/nba.dart';

BoxDecoration listTileDecoration = const BoxDecoration();

class PlayersPage extends LoggedPage {
  const PlayersPage({required coachId, super.key}) : super(coachId: coachId);

  @override
  LoggedPageState createState() => PlayersPageState();
}

class PlayersPageState extends LoggedPageState {
  PlayersPageState() {
    getNbaTeams().then((res) {
      setState(() {
        teams = {
          for (var t in res) t.tricode: Tuple2(first: t.teamId, second: false)
        };
      });
    });
  }

  FantaTeam fantaTeam = FantaTeam.empty();

  Map<String, int> indexedRoles = {
    "Guards": 0,
    "Forwards": 1,
    "Centers": 2,
    "Head Coach": 3,
  };
  int showingIndex = 0;

  Map<String, bool> positions = {"G": false, "F": false, "C": false, "HC": false};
  Map<String, Tuple2<String, bool>> teams = {};
  String search = "";

  Widget buildPlayersList(
      BuildContext context, AsyncSnapshot<List<NbaPerson>> snapshot) {
    return Container(
      child: snapshot.hasData
          ? ListView(
              children: applyFilters(snapshot.data!, positions, teams, search)
                  .map((p) => playerTile(p, Icons.add, () => addToTeam(widget.coachId, p) )).toList()
            )
          : const Center(child: CircularProgressIndicator(),),
    );
  }

  @override
  Widget content(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            padding: defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSearchFilter((newValue) {
                  setState(() {
                    search = newValue;
                  });
                }),
                const SizedBox(
                  width: 10.0,
                ),
                buildAlertDialogFilter(
                    context,
                    "Positions",
                    4,
                    ListView(
                        shrinkWrap: true,
                        children: positions.keys
                            .map((k) => CheckboxListTile(
                                title: Text(k),
                                value: positions[k],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    positions[k] = newValue!;
                                  });
                                  Navigator.pop(context);
                                }))
                            .toList())),
                const SizedBox(
                  width: 10.0,
                ),
                buildAlertDialogFilter(
                    context,
                    "Teams",
                    3,
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2),
                        child: ListView(
                            shrinkWrap: true,
                            children: teams.keys
                                .map((k) => CheckboxListTile(
                                    title: Text(k),
                                    value: teams[k]!.second,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        teams[k] = Tuple2(
                                            first: teams[k]!.first,
                                            second: newValue!);
                                      });
                                      Navigator.pop(context);
                                    }))
                                .toList())))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getNbaPlayersAndHeadCoaches(),
              builder: buildPlayersList,
            ),
          ),
        ],
      );
}

Widget playerTile(NbaPerson p, IconData icon, Function() onPressed) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: listTileDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 20,
                child: Text(
                  p.firstName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Expanded(
                flex: 30,
                child: Text(
                  p.lastName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Expanded(flex: 22, child: Center(child: Text(p.pos))),
            Container(
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  icon: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  onPressed: onPressed,
                ))
          ],
        ),
      ),
      const Divider(
        color: Colors.blueGrey,
        height: 3,
      )
    ],
  );
}

