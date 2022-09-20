import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/pages/players/filters.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/tuples.dart';
import 'package:flutter/material.dart';

import '../../api/db.dart';
import '../../api/fanta.dart';
import '../../api/nba.dart';

BoxDecoration listTileDecoration = const BoxDecoration();

class MyTeamPage extends LoggedPage {
  const MyTeamPage({required coachId, super.key}) : super(coachId: coachId);

  @override
  LoggedPageState createState() => MyTeamPageState();
}

class MyTeamPageState extends LoggedPageState {
  MyTeamPageState() {
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

  Map<String, bool> positions = {"G": false, "F": false, "C": false};
  Map<String, Tuple2<String, bool>> teams = {};
  String search = "";

  Widget buildPlayersList(
      BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return Container(
      child: snapshot.hasData
          ? ListView(
              children: applyFilters(snapshot.data!, positions, teams, search)
                  .map((p) => playerTile(p, "+", () => addPlayer(widget.coachId, p) )).toList()
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
              future: getNbaPlayers(),
              builder: buildPlayersList,
            ),
          ),
        ],
      );
}

Widget playerTile(NbaPlayer p, String buttonText, Function() onPressed) {
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
                  icon: const Icon(
                    Icons.add,
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

ListTile headCoachTile(NbaHeadCoach hc, String buttonText, Function() onPressed) {
  return ListTile(
    minVerticalPadding: -1.0,
    contentPadding: EdgeInsets.zero,
    title: Container(
      padding: defaultPadding,
      decoration: listTileDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex:20, child: Text(hc.firstName)),
          Expanded(flex:30, child: Text(hc.lastName)),
          const Expanded(flex:22, child: Center(child: Text("HC"))),
          Expanded(flex:10, child: BasicStyledButton(text: buttonText, onPressed: onPressed)),
        ],
      ),
    ),
  );
}
