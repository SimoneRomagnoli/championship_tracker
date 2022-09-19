import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/api/fanta.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/tuples.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:championship_tracker/pages/players/players_page.dart';

import '../api/nba.dart';
import '../pages/players/filters.dart';

class MyTeamV2Page extends StatefulWidget {
  const MyTeamV2Page({Key? key}) : super(key: key);

  @override
  State<MyTeamV2Page> createState() => _MyTeamV2PageState();
}

class _MyTeamV2PageState extends State<MyTeamV2Page> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNbaTeams().then((res) {
      setState(() {
        teams = {
          for (var t in res) t.tricode: Tuple2(first: t.teamId, second: false)
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text('Open bottom bar'),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return bottomSheet(context);
                });
          },
        ),
      ),
    );
  }

  Widget buildPlayersList(
      BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: defaultContainerDecoration,
      child: snapshot.hasData
          ? ListView(
              children: applyFilters(snapshot.data!, positions, teams, search)
                  .map((p) => playerTile(p, "+", () {
                        setState(() => fantaTeam.addPlayer(p));
                      }))
                  .toList())
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return content(context);
  }

  Widget content(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 30,
          ),
          /*Container(
        decoration: defaultContainerDecoration,
        padding: defaultPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (String role in indexedRoles.keys) BasicStyledButton(text: role, onPressed: () {
                  setState(() {
                    showingIndex = indexedRoles[role]!;
                  });
                })
              ],
            ),
            IndexedStack(
              index: showingIndex,
              children: [for (String role in indexedRoles.keys.map((c) => c.toLowerCase())) ListView(children: getRoleInTeam(fantaTeam, role))]
            )
          ],
        ),
      ),*/
          Container(
            decoration: defaultContainerDecoration,
            padding: defaultPadding,
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSearchFilter((newValue) {
                  setState(() {
                    search = newValue;
                  });
                }),
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
  


  

/*
          */