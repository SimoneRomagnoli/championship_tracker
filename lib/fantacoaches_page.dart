import 'package:championship_tracker/pages.dart';
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
    mainAxisAlignment: MainAxisAlignment.center,
    children: snapshot.hasData ? snapshot.data!.map((coach) => Text(coach.id)).toList() : [],
  );
}