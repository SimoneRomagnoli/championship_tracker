import 'package:flutter/material.dart';

import '../../api/fanta.dart';
import '../../api/nba.dart';
import '../../style/style.dart';
import '../fantacoaches/fantacoaches_page.dart';
import '../players/players_page.dart';

BoxDecoration navbarDecoration = const BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: Colors.black12,
    )
  ),
);

Widget topNavbar(BuildContext context, FantaCoach fantaCoach) {
  return Padding(
    padding: defaultPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BasicStyledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PlayersPage(coachId: fantaCoach.id,);
              }));
            },
            text: "MyTeam"
        ),
        BasicStyledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FantaCoachesPage(coachId: fantaCoach.id,);
              }));
            },
            text: "FantaCoaches"
        )
      ],
    )
  );
}