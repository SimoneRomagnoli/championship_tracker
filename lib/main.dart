import 'package:championship_tracker/players_page.dart';
import 'package:flutter/material.dart';
import 'db.dart';
import 'nba.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Championship Tracker',
      theme: ThemeData( primarySwatch: Colors.deepOrange,),
      home: const PlayersPage(title: 'Championship Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FantaCoach> fantaCoaches = [];

  void reloadCoaches() {
    getFantaCoaches().then((res) {
      setState(() {
        fantaCoaches = res;
      });
    });
  }

  Widget coachesColumn(BuildContext context, AsyncSnapshot<List<FantaCoach>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: snapshot.hasData ? snapshot.data!.map((coach) => Text(coach.id)).toList() : [],
    );
  }

  Widget teamsColumn(BuildContext context, AsyncSnapshot<List<NbaTeam>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: snapshot.hasData ? snapshot.data!.map((team) => Text(team.fullName)).toList() : [],
    );
  }

  Widget playersColumn(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: snapshot.hasData ? snapshot.data!.map((player) => playerRow(player)).toList() : [],
    );
  }

  Widget playerRow(NbaPlayer player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(child: Text(player.firstName)),
        Center(child: Text(player.lastName)),
        Center(child: Text(player.pos)),
        Center(
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => print("${player.personId} ${player.lastName}"),
          )
        ),
      ],
    );
  }

  List<Widget> playerGridRow(NbaPlayer player) {
    return  [
      Center(child: Text(player.firstName)),
      Center(child: Text(player.lastName)),
      Center(child: Text(player.pos)),
      Center(
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => print("${player.personId} ${player.lastName}"),
          )
      ),
    ];
  }

  Widget buildPlayersGrid(BuildContext context, AsyncSnapshot<List<NbaPlayer>> snapshot) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        children: snapshot.hasData
            ? snapshot.data!.map((player) => playerGridRow(player)).expand((e) => e).toList()
            : []
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("NBA Players"),
              Expanded(
                child: FutureBuilder(
                  future: getNbaPlayers(),
                  builder: buildPlayersGrid,
                ),
              ),
            ],
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: printPlayers,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
       */
    );
  }
}
