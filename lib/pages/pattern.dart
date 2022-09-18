import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/api/nba.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import 'navbar/navbar.dart';

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
        appBar: AppBar(
            title: Text(widget.title)
        ),
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
        )
    );
  }
}

abstract class LoggedPage extends DefaultPage {
  const LoggedPage({Key? key, required title}) : super(key: key, title: title);

  @override
  LoggedPageState createState();
}

abstract class LoggedPageState extends DefaultPageState {
  LoggedPageState({Key? key, required String coachId}) {
    getFantaCoaches().then((res) {
      setState(() {
        fantacoach = res.firstWhere((coach) => coach.id == coachId);
      });
    });
  }

  FantaCoach fantacoach = FantaCoach("", "", "");

  @override
  Widget content(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${fantacoach.firstName} ${fantacoach.lastName}'s team")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: navbarDecoration,
            child: topNavbar(context, fantacoach),
          ),
          Expanded(
              child: Center(
                child: Padding(
                  padding: defaultPadding,
                  child: content(context),
                ),
              ),
          )
        ],
      )
    );
  }
}



