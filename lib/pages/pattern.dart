import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../api/fanta.dart';
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

  FantaCoach fantacoach = FantaCoach.empty();

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



