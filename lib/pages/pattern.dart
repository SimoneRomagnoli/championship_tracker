import 'package:championship_tracker/pages/fantacoaches/fantacoach_page.dart';
import 'package:championship_tracker/pages/team/team.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../models/fanta.dart';
import '../network/manager.dart';

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
    NetworkManager.getFantaCoaches().then((res) {
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
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueGrey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Players',),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Team'),
            BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye), label: 'Fantacoaches')
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
    return [0, 3, 3];
  }

  List<String> getPageTitle() {
    return [
      "Players",
      "${fantacoach.firstName} ${fantacoach.lastName}'s team",
      "Fantacoach"
    ];
  }

  List<Widget> getPageList(BuildContext mContext) {
    return [
      content(context),
      TeamPage(coachId: fantacoach.id),
      FantaCoachPage(coachId: fantacoach.id)
    ];
  }
}
