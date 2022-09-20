import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/pages/pattern.dart';
import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../api/fanta.dart';

class TeamPage extends LoggedPage {
  const TeamPage({required super.coachId, super.key});

  @override
  LoggedPageState createState() => TeamPageState();
}

class TeamPageState extends LoggedPageState {
  @override
  Widget content(BuildContext context) {
    return FutureBuilder(
      future: getFantaTeam(widget.coachId),
      builder: buildFantaTeam,
    );
  }

  Widget buildFantaTeam(BuildContext context, AsyncSnapshot<FantaTeam> snapshot) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: defaultContainerDecoration,
      child: ListView(
        children: snapshot.hasData
          ? snapshot.data!.players
              .map((p) => playerTile(p, "-", () => removePlayer(widget.coachId, p)))
              .toList()
            .also((it) { if (snapshot.data!.headCoach != null) it.insert(0, headCoachTile(snapshot.data!.headCoach!, "-", () => null)); })
          : [],
      ),
    );
  }
}

