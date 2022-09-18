import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../api/db.dart';
import '../../api/nba.dart';

class FantaCoachesPage extends LoggedPage {
  const FantaCoachesPage({required this.coachId, super.key}) : super(title: "FantaCoaches");

  final String coachId;
  @override
  LoggedPageState createState() => FantaCoachesPageState(coachId: coachId);
}

class FantaCoachesPageState extends LoggedPageState {
  FantaCoachesPageState({required String coachId}) : super(coachId: coachId) {

  }

  @override
  Widget content(BuildContext context) => Column(
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
  return Container(
    decoration: defaultContainerDecoration,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: snapshot.hasData
          ? snapshot.data!
          .toList().also((l) => l.sort((a, b) => a.firstName.compareTo(b.firstName)))
          .map((coach) => Text("${coach.firstName} ${coach.lastName}"))
          .toList()
          : [],
    ),
  );
}