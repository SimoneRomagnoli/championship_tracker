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
      home: const MyHomePage(title: 'Championship Tracker'),
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

  void printPlayers() {
    getNbaPlayers().then((players) => print(players[0].firstName));
  }

  Widget coachesColumn(BuildContext context, AsyncSnapshot<List<FantaCoach>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: snapshot.hasData ? snapshot.data!.map((coach) => Text(coach.id)).toList() : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Here is the list of all the fanta coaches:',),
            FutureBuilder(
              future: getFantaCoaches(),
              builder: coachesColumn,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: printPlayers,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
