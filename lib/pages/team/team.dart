import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../models/fanta.dart';
import '../../models/nba.dart';
import '../../network/manager.dart';
import '../../utils/tuples.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({required this.coachId, super.key});

  final String coachId;

  @override
  TeamPageState createState() => TeamPageState();
}

class TeamPageState extends State<TeamPage> {
  int spendingCredits = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
            padding: defaultPadding,
            decoration: defaultContainerDecoration,
            child: FutureBuilder(
              future: NetworkManager.getFantaCoach(widget.coachId),
              builder: buildHeader,
            ),

        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: defaultPadding,
            decoration: defaultContainerDecoration,
            child: FutureBuilder(
              future: NetworkManager.getTeamPageInfo(widget.coachId),
              builder: buildFantaTeam,
            ),
          )
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context, AsyncSnapshot<FantaCoach> snapshot) {
    return snapshot.hasData
        ? Container(
            padding: defaultPadding,
            decoration: defaultContainerDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(children: [Text("Team: ${snapshot.data!.teamName}", style: titlesTextStyle,)]),
                      Row(children: [Text("Credits: ${snapshot.data!.credits}", style: titlesTextStyle,)])
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        focusColor: Colors.blue,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue, width: 3)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue, width: 3)),
                        hintText: "Spend",
                        prefixIcon: Icon(
                          Icons.money_off,
                          color: Colors.white,
                        )),
                    onChanged: (newValue) { if (newValue != "") spendingCredits = int.parse(newValue);},
                    keyboardType: TextInputType.number,
                  )
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.money_off,
                      color: Colors.white,
                    ),
                    onPressed: () => NetworkManager.spendCredits(widget.coachId, spendingCredits),
                  )
                ),
              ]
            )
          )
        : const Center();
  }

  Widget buildFantaTeam(BuildContext context, AsyncSnapshot<Tuple2<FantaTeam, List<NbaTeam>>> snapshot) {
    FantaTeam team = snapshot.hasData ? snapshot.data!.first : FantaTeam.empty();
    List<NbaTeam> teams = snapshot.hasData ? snapshot.data!.second : [];
    return snapshot.hasData ? Container(
      padding: EdgeInsets.zero,
      decoration: defaultContainerDecoration,
      child: ListView(
        children: team.players
              .map((p) => playerTile(p, teams.firstWhere((t) => t.teamId == p.teamId), [], Icons.remove, () => NetworkManager.removeFromTeam(widget.coachId, p)))
              .toList()
            .also((it) {
              if (snapshot.data!.first.headCoach != null) it.insert(0, playerTile(team.headCoach!, teams.firstWhere((t) => t.teamId == team.headCoach!.teamId), [], Icons.remove, () => NetworkManager.removeFromTeam(widget.coachId, team.headCoach!)));
            }),
      ),
    )
    : const Center(child: CircularProgressIndicator());
  }
}

