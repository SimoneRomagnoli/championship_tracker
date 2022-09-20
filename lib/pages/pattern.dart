import 'dart:ffi';

import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/pages_v2/fantacoach_page.dart';
import 'package:championship_tracker/pages_v2/my_team_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../api/fanta.dart';

abstract class DefaultPage extends StatefulWidget {
  const DefaultPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  DefaultPageState createState();
}

abstract class DefaultPageState extends State<DefaultPage> {
  DefaultPageState({Key? key});

  Widget content(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text(widget.title)),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: defaultPadding,
              child: content(context),
            ),
          ),
        )
      ],
    ));
  }
}

abstract class LoggedPage extends StatefulWidget {
  const LoggedPage({Key? key, required this.coachId}) : super(key: key);

  final String coachId;

  @override
  LoggedPageState createState();
}

abstract class LoggedPageState extends State<LoggedPage> {
  LoggedPageState({Key? key}) {
    getFantaCoaches().then((res) {
      setState(() {
        fantacoach = res.firstWhere((coach) => coach.id == widget.coachId);
      });
    });
  }

  int _selectedIndex = 0;

  FantaCoach fantacoach = FantaCoach.empty();

  Widget content(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getPageTitle()[_selectedIndex]),
          elevation: elevationAppBar()[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueGrey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: 'Players',
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Team'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Fantacoaches'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Impostazioni')
          ],
        ),
        body: getPageList(context)[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<double> elevationAppBar() {
    return [0, 3, 3, 3];
  }

  List<String> getPageTitle() {
    return [
      "Players",
      "${fantacoach.firstName} ${fantacoach.lastName}'s team",
      "Fantacoach",
      "Impostazioni"
    ];
  }

  List<Widget> getPageList(BuildContext mContext) {
    return [
      content(context),
      const MyTeamV2Page(),
      const FantaCoachPage(),
      const Center(
        child: Text('Impostazioni'),
      )
    ];
  }
}
