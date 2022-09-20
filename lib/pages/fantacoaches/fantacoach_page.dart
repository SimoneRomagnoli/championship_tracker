import 'package:championship_tracker/pages/team/team.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:flutter/material.dart';

import '../../models/fanta.dart';
import '../../network/manager.dart';

class FantaCoachPage extends StatefulWidget {
  const FantaCoachPage({Key? key, required this.coachId}) : super(key: key);

  final String coachId;

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
            future: NetworkManager.getFantaCoaches(),
            builder: coachesColumn,
          ),
        ),
      ],
    ));
  }

  Widget coachesColumn(
      BuildContext context, AsyncSnapshot<List<FantaCoach>> snapshot) {
    return ListView(
      children: snapshot.hasData
          ? snapshot.data!
              .toList()
              .also(
                  (l) => l.sort((a, b) => a.firstName.compareTo(b.firstName)))
              .map((coach) => fantaCoachTile(coach, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeamPage(coachId: coach.id, owner: false,)));
              }))
              .toList()
          : [const Center(child: CircularProgressIndicator())],
    );
  }

  Widget fantaCoachTile(FantaCoach fc, Function() onPressed) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 10,
                  child: Text(
                    fc.firstName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 10,
                  child: Text(
                    fc.lastName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(flex: 20, child: Center(child: Text(fc.teamName))),
              Expanded(flex: 10, child: Center(child: Text("${fc.credits} CR"))),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.expand_more,
                      color: Colors.white,
                    ),
                    onPressed: onPressed,
                  ))
            ],
          ),
        ),
        const Divider(
          color: Colors.blueGrey,
          height: 3,
        )
      ],
    );
  }
}
