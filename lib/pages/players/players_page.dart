import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/pages/players/filters.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/tuples.dart';
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

class PlayersPage extends LoggedPage {
  const PlayersPage({required this.coachId, super.key}) : super(title: "Players");

  final String coachId;

  @override
  LoggedPageState createState() => PlayersPageState(coachId: coachId);
}

class PlayersPageState extends LoggedPageState {
  PlayersPageState({required String coachId}) : super(coachId: coachId) {
    getNbaTeams().then((res) {
      setState(() {
        teams = { for (var t in res) t.tricode : Tuple2(first: t.teamId, second: false) };
      });
    });
  }

  Map<String, bool> positions = { "G" : false, "F" : false, "C" : false };
  Map<String, Tuple2<String, bool>> teams = {};
  String search = "";

  Widget buildPlayersList(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return Container(
        padding: EdgeInsets.zero,
        decoration: defaultContainerDecoration,
        child: snapshot.hasData
            ? ListView(
              children: applyFilters(snapshot.data!, positions, teams, search)
                  .map((p) => ListTile(
                  minVerticalPadding: -1.0,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    padding: defaultPadding,
                    decoration: listTileDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:20, child: Text(p.firstName)),
                        Expanded(flex:30, child: Text(p.lastName)),
                        Expanded(flex:22, child: Center(child: Text(p.pos))),
                        Expanded(flex:10, child: BasicStyledButton(text: "+", onPressed: () {})),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildSearchFilter((newValue) {
              setState(() {
                search = newValue;
              });
            }),
            buildAlertDialogFilter(context, "Positions", 4, ListView(
                shrinkWrap: true,
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
            )),
            const SizedBox(width: 10.0,),
            buildAlertDialogFilter(context, "Teams", 3, ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
              child: ListView(
                  shrinkWrap: true,
                  children: teams.keys
                      .map((k) =>
                      CheckboxListTile(
                          title: Text(k),
                          value: teams[k]!.second,
                          onChanged: (bool? newValue) {
                            setState(() {
                              teams[k] = Tuple2(first: teams[k]!.first, second: newValue!);
                            });
                            Navigator.pop(context);
                          }
                      )
                  ).toList()
              )
            ))
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