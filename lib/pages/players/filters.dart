import 'package:flutter/material.dart';

import '../../models/nba.dart';
import '../../style/style.dart';
import '../../utils/tuples.dart';

List<NbaPerson> applyFilters(
    List<NbaPerson> players,
    Map<String, bool> positions,
    Map<String, Tuple2<String, bool>> teams,
    String search) {
  return players
      .where((p) =>
          filterByPosition(p, positions) &&
          filterByTeam(p, teams) &&
          filterByName(p, search))
      .toList();
}

bool filterByName(NbaPerson p, String search) {
  return search == "" ||
      p.firstName.contains(RegExp(search, caseSensitive: false)) ||
      p.lastName.contains(RegExp(search, caseSensitive: false));
}

bool filterByPosition(NbaPerson p, Map<String, bool> positions) {
  return p.pos.contains(RegExp(positions.keys
          .where((k) => positions[k]!)
          .reduce((acc, s) => "$acc|$s")));
}

bool filterByTeam(NbaPerson p, Map<String, Tuple2<String, bool>> teams) {
  return !teams.values
          .reduce((acc, e) => Tuple2(first: "", second: acc.second || e.second))
          .second ||
      teams[teams.keys.firstWhere((k) => teams[k]!.first == p.teamId)]!
          .second;
}

Widget buildSearchFilter(Function(String) onChanged) {
  return Expanded(
    flex: 4,
    child: Container(
      padding: defaultPadding,
      child: TextField(
        cursorColor: Colors.white,
        decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(color: Colors.white, width: 3)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(color: Colors.white, width: 3)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(color: Colors.white, width: 3)),
            hintText: "Search",
            prefixIcon: Icon(
              Icons.people_alt_outlined,
              color: Colors.white,
            )),
        onChanged: onChanged,
      ),
    ),
  );
}

Widget buildAlertDialogFilter(
    BuildContext context, String title, int flex, Widget content) {
  return title == "Positions"
      ? GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white60,
            ),
            height: 40,
            width: 40,
            child: Center(
              child: Image.asset(
                'assets/player.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
          onTap: () {
            myShowDialog(context, title, content);
          },
        )
      : GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white60,
            ),
            height: 40,
            width: 40,
            child: Center(
              child: Image.asset(
                'assets/teams.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
          onTap: () {
            myShowDialog(context, title, content);
          },
        );
}

void myShowDialog(BuildContext context, String title, Widget content) {
  showDialog(
      context: context,
      builder: (context) => Wrap(
            children: [
              AlertDialog(
                title: Text(title),
                content: Container(
                    decoration: defaultContainerDecoration,
                    padding: EdgeInsets.zero,
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: content),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              )
            ],
          ));
}
