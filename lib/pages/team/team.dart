import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../api/fanta.dart';
import '../../api/nba.dart';
import '../../utils/tuples.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({required this.coachId, super.key});

  final String coachId;

  @override
  TeamPageState createState() => TeamPageState();
}

class TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeamPageInfo(widget.coachId),
      builder: buildFantaTeam,
    );
  }

  Widget buildFantaTeam(BuildContext context, AsyncSnapshot<Tuple2<FantaTeam, List<NbaTeam>>> snapshot) {
    FantaTeam team = snapshot.hasData ? snapshot.data!.first : FantaTeam.empty();
    List<NbaTeam> teams = snapshot.hasData ? snapshot.data!.second : [];
    return snapshot.hasData ? Container(
      padding: EdgeInsets.zero,
      decoration: defaultContainerDecoration,
      child: ListView(
        children: team.players
              .map((p) => playerTile(p, teams.firstWhere((t) => t.teamId == p.teamId), [], Icons.remove, () => removeFromTeam(widget.coachId, p)))
              .toList()
            .also((it) {
              if (snapshot.data!.first.headCoach != null) it.insert(0, playerTile(team.headCoach!, teams.firstWhere((t) => t.teamId == team.headCoach!.teamId), [], Icons.remove, () => removeFromTeam(widget.coachId, team.headCoach!)));
            }),
      ),
    )
    : const Center(child: CircularProgressIndicator());
  }
}

