import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../api/fanta.dart';

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
      future: getFantaTeam(widget.coachId),
      builder: buildFantaTeam,
    );
  }

  Widget buildFantaTeam(BuildContext context, AsyncSnapshot<FantaTeam> snapshot) {
    return snapshot.hasData ? Container(
      padding: EdgeInsets.zero,
      decoration: defaultContainerDecoration,
      child: ListView(
        children: snapshot.data!.players
              .map((p) => playerTile(p, Icons.remove, () => removePlayer(widget.coachId, p)))
              .toList()
            .also((it) { if (snapshot.data!.headCoach != null) it.insert(0, playerTile(snapshot.data!.headCoach!, Icons.remove, () => null)); }),
      ),
    )
    : const Center(child: CircularProgressIndicator());
  }
}

