import 'package:flutter/material.dart';

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

Widget topNavbar(BuildContext context) {
  return Padding(
    padding: defaultPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BasicStyledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PlayersPage();
              }));
            },
            text: "Players"
        ),
        BasicStyledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FantaCoachesPage();
              }));
            },
            text: "FantaCoaches"
        )
      ],
    )
  );
}