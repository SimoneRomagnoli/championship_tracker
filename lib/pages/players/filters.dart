import 'package:flutter/material.dart';

import '../../api/nba.dart';
import '../../style/style.dart';
import '../../utils/tuples.dart';

List<NbaPlayer> applyFilters(List<NbaPlayer> players, Map<String, bool> positions, Map<String, Tuple2<String, bool>> teams, ) {
  return players.where(
          (p) => filterByPosition(p, positions) && filterByTeam(p, teams)
  ).toList();
}

bool filterByPosition(NbaPlayer player, Map<String, bool> positions) {
  return !positions.values.reduce((acc, e) => acc || e) ||
      player.pos.contains(RegExp(positions.keys.where((k) => positions[k]!).reduce((acc, s) => "$acc|$s")));
}

bool filterByTeam(NbaPlayer player, Map<String, Tuple2<String, bool>> teams) {
  return !teams.values.reduce((acc, e) => Tuple2(first: "", second: acc.second || e.second)).second ||
      teams[teams.keys.firstWhere((k) => teams[k]!.first == player.teamId)]!.second;
}

Widget buildSearchFilter() {
  return Expanded(
    flex: 4,
    child: Container(
      padding: defaultPadding,
      child: const TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search"
        ),
      ),
    ),
  );
}

Widget buildAlertDialogFilter(BuildContext context, String title, int flex, Widget content) {
  return Expanded(
      flex: flex,
      child:  BasicStyledButton(
        text: title,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Wrap(
                children: [
                  AlertDialog(
                    title: Text(title),
                    content: Container(
                        decoration: defaultContainerDecoration,
                        padding: EdgeInsets.zero,
                        child: content
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
  );
}