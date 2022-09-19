import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../api/fanta.dart';

class FantaCoachPage extends StatefulWidget {
  const FantaCoachPage({Key? key}) : super(key: key);

  @override
  State<FantaCoachPage> createState() => _FantaCoachPageState();
}

class _FantaCoachPageState extends State<FantaCoachPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder(
            future: getFantaCoaches(),
            builder: coachesColumn,
          ),
        ),
      ],
    ));
  }

  Widget coachesColumn(
      BuildContext context, AsyncSnapshot<List<FantaCoach>> snapshot) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: snapshot.hasData
            ? snapshot.data!
                .toList()
                .also(
                    (l) => l.sort((a, b) => a.firstName.compareTo(b.firstName)))
                .map((coach) => Text("${coach.firstName} ${coach.lastName}"))
                .toList()
            : [],
      ),
    );
  }
}
