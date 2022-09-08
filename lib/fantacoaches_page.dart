import 'package:championship_tracker/pages.dart';
import 'package:championship_tracker/utils.dart';
import 'package:flutter/material.dart';

import 'db.dart';
import 'nba.dart';

class FantaCoachesPage extends ChampionshipTrackerPage {
  const FantaCoachesPage({super.key}) : super(title: "FantaCoaches");

  @override
  ChampionshipTrackerPageState createState() => FantaCoachesPageState();
}

class FantaCoachesPageState extends ChampionshipTrackerPageState {
  FantaCoachesPageState();

  @override
  Widget content = Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const Text("Fanta Coaches"),
      Expanded(
        child: FutureBuilder(
          future: getFantaCoaches(),
          builder: coachesColumn,
        ),
      ),
    ],
  );
}

Widget coachesColumn(BuildContext context, AsyncSnapshot<List<FantaCoach>> snapshot) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: snapshot.hasData
        ? snapshot.data!
            .toList().also((l) => l.sort((a, b) => a.firstName.compareTo(b.firstName)))
            .map((coach) => Text("${coach.firstName} ${coach.lastName}"))
            .toList()
        : [],
  );
}